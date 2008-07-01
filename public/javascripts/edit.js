/**
 * Ajax editing for books and authors.
 *
 * Edit forms are dynamically loaded into the current page and replaced with
 * updated content on save.
 */
$(document).ready(function() {
  /**
   * When an edit button is clicked, load the edit form for that book.
   */
  $('#content').delegate('click', {
    '.edit': function(event) {
      var link = $(event.target);
      
      if (link.is('a')) {
        $.get(link[0].href, {}, function(response) {
          var data = response;
          
          link.parents('.book, .author').hide('normal', function() {
            $(this).html(data);
          }).show('normal');
        });
        
        return false;
      }
    }
  });
  
  /**
   * When an edit form is submitted, replace it with the book details.
   *
   * TODO: add error handling so that a failed request doesn't replace the form
   * with nothing at all.
   */
  $('#content').delegate('submit', {
    'form.edit_book, form.edit_author': function(event) {
      var form = $(event.target);
      
      $.post(event.target.action, form.serialize(), function(response) {
        var new_content = $(response).hide();
        
        form.parents('.book, .author').hide('normal', function() {
          $(this).replaceWith(new_content);
          new_content.show('normal');
        });
      });

      return false;
    }
  });
});
