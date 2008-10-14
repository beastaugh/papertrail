jQuery.delegate = function(rules, scope) {
  return function(e) {
    var target = jQuery(e.target);
    for (var selector in rules)
      if (target.is(selector)) return rules[selector].apply(scope || this, jQuery.makeArray(arguments));
  };
};

var Editable = function(wrapper, config) {
  if (!config) config = {};
  var link = config.link || '.edit';
  var self = this;
  
  this.wrapper = jQuery(wrapper);
  this.links = jQuery(link);
  this.link = this.wrapper.find(link)[0];
  this.view = this.wrapper.children(config.view || '.content');
  this.view.after('<div class="form" style="display:none;"></div>');
  this.form = this.view.next();
  
  this.transition = function(height, operations, scope) {
    var wrapper = this.wrapper;
    wrapper.children().each(function() {
      jQuery(this).css({width: wrapper.width()});
    });
    wrapper.animate({opacity: 0, height: height}, function() {
      operations.call(scope || null);
      wrapper.animate({opacity: 1}, function() {
        this.style.height = '';
      });
    });
    return this;
  };
  
  this.cleanup = function() {
    this.wrapper.children().each(function() {
      this.style.width = '';
    });
  };
  
  this.edit = function() {
    var self = this;
    jQuery.get(this.link.href, {}, function(response) {
      self.form.html(response);
      self.form.children('.book-form').prepend('<p class="cancel button">Cancel</p>');
      self.links.fadeOut();
      self.transition(self.form.height(), function() {
        this.view.hide();
        this.form.show();
      }, self);
    });
    return false;
  };
  
  this.list = function(new_content) {
    if (new_content) this.view.html(new_content);
    this.transition(this.view.height(), function() {
      this.form.hide().html('');
      this.view.show();
      this.links.fadeIn();
    }, this);
    this.cleanup();
  };

  this.remove = function() {
    var self = this;
    this.wrapper.fadeOut(function() {
      self.wrapper.remove();
      self.links.fadeIn();
    });
    return false;
  };
  
  this.post = function(e, callback) {
    var form = e.target;
    jQuery.post(form.action, jQuery(form).serialize(), callback);
  };
  
  this.cancel = function() {
    this.list();
    return false;
  };
  
  this.save = function(e) {
    var self = this;
    this.post(e, function(response, status) {
      if ('success' == status) self.list(response);
    });
    return false;
  };
  
  this.destroy = function(e) {
    var self = this;
    var ays = confirm("Are you sure?");
    if (ays) this.post(e, function(response, status) {
      if ('success' == status) self.remove();
    });
    return false;
  };
  
  jQuery(this.wrapper).click(jQuery.delegate({
    '.edit': this.edit,
    '.cancel': this.cancel
  }, this)).submit(jQuery.delegate({
    'form.edit_form': this.save,
    'form.button-to': this.destroy
  }, this));
};
