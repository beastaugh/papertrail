/**
 * Ajax editing for books and authors.
 *
 * Edit forms are dynamically loaded into the current page and replaced with
 * updated content on save.
 */
$(document).ready(function() {
  var edit_links = $('#content .edit');
  
  /**
   * When an edit button is clicked, load the edit form for that book.
   */
  $('#content').delegate('click', {
    '.edit': function(event) {
      
      var link = $(event.target);
      
      if (link.is('a')) {
        $.get(link[0].href, {}, function(response) {
          var data = response;
          
          edit_links.fadeOut();
          
          link.parents('.book, .author').fadeOut('normal', function() {
            $(this).html(data);
          }).fadeIn();
        });
        
        return false;
      }
    }
  });
  
  /**
   * When an edit form is submitted, replace it with the book details.
   */
  $('#content').delegate('submit', {
    'form.edit_book, form.edit_author': function(event) {
      var form = $(event.target);
      
      $.post(event.target.action, form.serialize(), function(response) {
        var new_content = $(response).hide();
        
        form.parents('.book, .author').fadeOut('normal', function() {
          $(this).replaceWith(new_content);
          new_content.fadeIn();
          edit_links.fadeIn();
        });
      });

      return false;
    }
  });
});
