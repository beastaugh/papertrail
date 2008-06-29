/**
 * Ajax editing for books: dynamically loads edit forms into the current
 * context and replaces them with updated content on save.
 *
 * TODO: refactor the code so it works for authors as well as books.
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
   * TODO: add error handling so that a failed request doesn't replace the form
   * with nothing at all.
   */
  $('#content').delegate('submit', {
    'form.edit_book': function(event) {
      var form = $(event.target);
      
      $.post(event.target.action, form.serialize(), function(response) {
        var content = $(response).find('.book');
        form.parents('.book').replaceWith(content);
      });

      return false;
    }
  });
});
