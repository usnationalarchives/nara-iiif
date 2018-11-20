namespace :bucket do
  namespace :temp do

    desc "Remove stale S3 objects in the `temp` prefix"
    task :clear => :environment do

      @client = Aws::S3::Client.new(
        region: ENV.fetch("S3_REGION"),
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
      )

      @bucket = Aws::S3::Bucket.new(ENV.fetch("S3_BUCKET_NAME"), client:@client)

      @bucket.objects(prefix:"temp").each do |summary|
        if summary.last_modified < 1.day.ago
          @bucket.object(summary.key).delete
          puts "Deleted #{@bucket.name}/#{summary.key}"
        end
      end

    end

  end
end
