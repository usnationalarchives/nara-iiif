# -----------------------------------------------------------------------------
# FulltextSearchable
# Peform fulltext queries over your model with stemming/lexemes
# -----------------------------------------------------------------------------
# To use this concern, your model must have a search_vector column of type
# `tsvector` to contain the fulltext lexeme. You will also need a GIN
# index to make sure that this isn’t insanely slow:
#
#   add_column :blog_posts, :search_vector, :tsvector
#   add_index  :blog_posts, :search_vector, using: :gin
#
# Your model should include the concern and then set a plan with:
#
#   has_fulltext_search plan: {
#     A: [:title],
#     B: [],
#     C: [],
#     D: [],
#   }
#
# The keys for this hash are the priority rankings for the text search,
# A is the higest and D is the lowest.
#
# The values are arrays of methods to call on this model.
# The methods should return a string to concatinate into the fulltext lexeme.
# You can omit grades you don’t want to use in your plan.
#
# This makes some keywords more important than others for search purposes,
# for example the "title" of a blog post would likely be rank A.
#
# You can then call the following methods to find each post with "red" and "roses" in it’s
# lexeme, sorted by relevance:
#
#   BlogPosts.fulltext_search("red roses").by_relevance
#
# The system proritizes words with a higher rank, but also ranks higher
# content that repeats given words more than once, or uses different forms of the
# given words. In this way, the search you build will likely favor "leaf" or
# permapage content over topics, categories, or index pages.

module FulltextSearchable

  extend ActiveSupport::Concern

  included do
    @fulltext_search_plan = {A:nil, B:nil, C:nil, D:nil}
    after_save :update_search_vector!
  end

  module ClassMethods

    attr_accessor :fulltext_search_plan

    # Sets the fulltext search plan to the given `plan`
    def has_fulltext_search(plan:{A:nil, B:nil, C:nil, D:nil})
      self.fulltext_search_plan = plan
    end

    # Performs a fulltext search looking for the keywords in `search_string`
    def fulltext_search(search_string)

      # Strip out !, (), &, and |, because these are search vector control characters
      # Remove extra spaces
      search_string = search_string.to_s.delete("()!&|").squish

      tsquery = sanitize_sql_array([
        %{replace(plainto_tsquery('%s')::text,' & ',' | ')::tsquery}, search_string
      ])

      relation = self.select(%{
        #{self.table_name}.*,
        ts_rank(#{self.table_name}.search_vector, #{tsquery}) AS search_ranking
      })

      return relation.where("#{tsquery} @@ #{self.table_name}.search_vector")

    end

    # Sorts a text search by relevance, can only be chained after `fulltext_search()`
    def by_relevance
      self.order("search_ranking DESC")
    end

  end

  # Constructs a tsvector statement using the configured `fulltext_search_plan`,
  # and returns the SQL string
  def tsvector_construction_string
    self.class.fulltext_search_plan.collect do |weight, methods|
      if methods.to_a.any?
        keywords = methods.collect { |method| self.send(method) }.join(" ")
        self.class.send(:sanitize_sql_array, [
          %{setweight(to_tsvector('%s'), '%s')},
          keywords, weight
        ])
      end
    end.compact.join(" || ").squish
  end

  # Saves the fulltext lexeme for this model
  def update_search_vector!
    ActiveRecord::Base.connection.execute(%{
      UPDATE #{self.class.table_name}
      SET search_vector = #{self.tsvector_construction_string}
      WHERE id = #{id}
    }.squish)
  end

end
