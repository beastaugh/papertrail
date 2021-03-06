jQuery.delegate = function(rules, scope) {
  return function(e) {
    var target = jQuery(e.target);
    for (var selector in rules)
      if (target.is(selector))
        return rules[selector].apply(scope || this, jQuery.makeArray(arguments));
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
  this.form = jQuery('<div class="form" style="display:none;"></div>');
  this.view.after(this.form);
  
  this.transition = function(height, operations, scope) {
    var wrapper = this.wrapper;
    var self = this;
    wrapper.children().each(function() {
      jQuery(this).css({width: wrapper.width()});
    });
    wrapper.animate({opacity: 0, height: height}, function() {
      operations.call(scope || null);
      wrapper.animate({opacity: 1});
    });
    return this;
  };
  
  this.edit = function() {
    var self = this;
    jQuery.get(this.link.href, {}, function(response) {
      var formContent = jQuery(response);
      formContent.children('form.edit_form').prepend('<p class="cancel button">Cancel</p>');
      self.form.html(formContent);
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
    this.transition(this.view.innerHeight(), function() {
      this.form.hide().html('');
      this.view.show();
      this.links.fadeIn();
    }, this);
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
  
  this.autofill = function(form, isbn) {
      var self = this, json;
      jQuery.post('/books/autofill', {isbn: isbn}, function(response, status) {
          if (status === 'success') {
              form = jQuery(form);
              json = jQuery.parseJSON(response);
              jQuery.each(response, function(name, value) {
                  form.find('#book_' + name).attr('value', value);
              });
          }
      });
  };
  
  this.cancel = function() {
    this.list();
    return false;
  };
  
  this.save = function(e) {
    var self, form, params;
    
    self   = this;
    form   = jQuery(e.target).serializeArray();
    params = jQuery.grep(form, function(item) {
        return item.name.match(/book\[\w+\]/) && item.value.length > 0;
    });
    
    if (params.length === 1 && jQuery.grep(params, function(item) {
        return item.name === 'book[isbn]';
    })) {
        self.autofill(e.target, params[0].value);
    } else {
        self.post(e, function(response, status) {
          if ('success' == status) self.list(response);
        });
    }
    
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

AutoFill = function(form) {
    this._form = jQuery(form);
    
    var self = this;
    
    this._form.submit(function(ev) {
        var form   = self._form.serializeArray(),
            params = jQuery.grep(form, function(item) {
                return item.name.match(/book\[\w+\]/) && item.value.length > 0;
            }),
            json, isbn;
        
        if (params.length === 1 && params[0].name === 'book[isbn]') {
            isbn = params[0].value;
            
            jQuery.post('/books/autofill', {isbn: isbn}, function(response, status) {
                if (status === 'success') {
                    json = jQuery.parseJSON(response);
                    jQuery.each(response, function(name, value) {
                        self._form.find('#book_' + name).attr('value', value);
                    });
                }
            });
            
            return false;
        }
    });
};
