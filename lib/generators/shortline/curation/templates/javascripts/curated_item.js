var attrs = {
  type: 'data-curated-type',
  children: 'data-curated-child'
};

var CuratedItemView = Backbone.View.extend({

  initialize: function() {
    // console.log('CuratedItemView initialized');

    // Child Elements
    this.$type = this.$('['+attrs.type+']'); // is the parent <select> type
    this.curationType = this.$type.attr(attrs.type);
    try {
      this.types =  JSON.parse(this.$type.attr('data-curated-types'));
    } catch(e) {
      console.error('Object missing [data-curated-types] attribute or value is not a valid json string', e);
    }
    this.$typeSelect = this.$type.find('select').first(); // is the parent <select> type
    this.$typeSelectOptions = this.$typeSelect.find("option");
    this.typesLength =
    this.$destroy = this.$('[data-destroy]'); // destory button
    this.parentName = this.$typeSelect.attr('name');
    // container div for the resource inputs
    this.$children = this.$('['+attrs.children+']');
    // Input Values
    this.typeVal = this.$typeSelect.val();

    if (!this.typeVal) {
      this.$typeSelect.removeAttr('name');
    }

    var selects = this.$('.searchable-select');
    selects.each(function() {
      new SearchableSelectView({
        el: $(this)
      })
    });

    this.cacheChildrenData()
      .toggleChildren()
      .toggleTypeName(this.typeVal)
      .toggleDestroyInput(!this.typeVal)
      .addEventListeners()
      .handleSingleType();
  },

  /**
   * Cache Children Data
   * this prevents from having to unnecesarily query the DOM by storing the name
   * attribute and child <select> element within the jQuery `data` object
   * @return {object} this - for functional chaining
   */
  cacheChildrenData: function() {
    this.$children.each(function(i, $child) {
      var $this = $(this);
      var $select = $this.find('select');
      $this.data({
        name: $select.attr('name'),
        $select: $select
      });
    });
    return this;
  },

  /**
   * Toggle Children Resourse Selects
   * show/hide child select elements based on the passed `type`. If no `type` is
   * passed, it will default to the current `typeVal` value set on the Backbone
   * View.
   * @param {string} typeVal - to match children against
   * @return {object} this - for functional chaining
   */
  toggleChildren: function(typeVal) {
    var self = this;
    typeVal = typeVal || this.typeVal || "";

    // Loop through each child element
    this.$children.each(function(i, $child) {
      var $this = $(this);

      // if data attribute match the current typeVal
      if ($this.data('curatedChild') === typeVal) {
        // show the element
        $this.show()
          // get the elements select child
          .data('$select')
            // enable the select
            .prop('disabled', false)
            // re-add it's name attribute so it's value can be passed when the
            // form is submitted
            .attr('name', $this.data('name'));
      }
      else {
        // hide the element
        $this.hide()
          // get the elements select child
          .data('$select')
            // disable dthe select and remove it's name so the value is not passed
            // when the form is submitted.
            .prop('disabled', true)
            .attr('name', '');
      }
    });
    return this;
  },

  /**
   * Add event listeners to children
   */
  addEventListeners: function() {
    this.$typeSelect.on('change', this.handleTypeChange.bind(this));
    return this;
  },

  events: {},

  /**
   * Handle Type Input Change
   * - updates the `typeVal` value
   * - toggles the children
   * @param {object} evt - jquery event passed by input change
   */
  handleTypeChange: function(evt) {
    this.typeVal = this.$typeSelect.val();
    var hasValue = !!this.typeVal;

    this.toggleTypeName(hasValue);
    this.toggleDestroyInput(!hasValue);
    this.toggleChildren();
  },

  /**
   * Update display when only a single type is available
   * - sets the select value to the only available option
   * - simulates type select change event
   * - hides the type select from view
   * @return {object} this - for functional chaining
   */
  handleSingleType: function() {
    // Check if only one type exists
    if (this.curationType === 'collection' && this.types.length <= 1 ) {
      // Set the value and trigger change event
      this.$typeSelect.val(this.types[0])
      this.handleTypeChange();
      this.$type.hide();
    }
    return this;
  },

  toggleTypeName: function(hasValue) {
    if (hasValue) {
      this.$typeSelect.attr('name', this.parentName);
    }
    else {
      this.$typeSelect.removeAttr('name');
    }
    return this;
  },

  toggleDestroyInput: function(destroy) {
    if (this.$destroy) {
      this.$destroy.val( destroy ? 1 : 0 );
    }
    return this;
  }

});

FormOrchestrator.register(".curated-item", "CuratedItemView");

$(".curated-item").each(function(index, $element) {
  new CuratedItemView({el:$element});
});
