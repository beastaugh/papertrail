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
   * A cross-browser fix is included: some browsers prepend the protocol and
   * domain to form actions, some don't. This is relevant because sometimes a
   * response needs filtering depending on whether the origin of the request
   * is the same as the target.
   *
   * TODO: add error handling so that a failed request doesn't replace the form
   * with nothing at all.
   */
  $('#content').delegate('submit', {
    'form.edit_book, form.edit_author': function(event) {
      var form = $(event.target);
      var action = event.target.action;
      
      $.post(action, form.serialize(), function(response) {
        var action_path, content = $(response).find('.book, .author');
        
        if (/^https?:\/\//.test(action)) {
          action_path = action;
        } else {
          action_path = document.location.protocol + '//' + document.location.host + action;
        }
        
        if (action_path != document.URL) {
          var title = content.find('.title');
          title.replaceWith('<h2 class="title"><a href="' + action + '">' + title.text() + '</a></h2>');
        }
        
        form.parents('.book, .author').replaceWith(content);
      });

      return false;
    }
  });
});
