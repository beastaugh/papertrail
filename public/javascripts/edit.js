$(document).ready(function() {
  $('#content').delegate('click', {
    '.edit': function(event) {
      var link = $(event.target);
      
      if (link.is('a')) {
        link.parents('.book').load(link[0].href + ' .book-form');
      }
      
      return false;
    }
  });
  
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
