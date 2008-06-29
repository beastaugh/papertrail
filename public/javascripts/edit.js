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
        link.parents('.book, .author').load(link[0].href + ' .book-form, .author-form');
        return false;
      }
    }
  });
  
  /**
   * When an edit form is submitted, replace it with the book details.
   *
   * TODO: be smarter about the current page context so that markup differences
   * between index and show pages, for example, are respected when dynamically
   * loading new content.
   *
   * TODO: add error handling so that a failed request doesn't replace the form
   * with nothing at all.
   */
  $('#content').delegate('submit', {
    'form.edit_book, form.edit_author': function(event) {
      var form = $(event.target);
      
      $.post(event.target.action, form.serialize(), function(response) {
        var content = $(response).find('.book, .author');
        form.parents('.book, .author').replaceWith(content);
      });

      return false;
    }
  });
});
