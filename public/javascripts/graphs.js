var compose = function() {
  var fns  = Array.prototype.slice.call(arguments),
      i    = fns.length - 1;
  
  return function() {
    var result = fns[i].apply(null, arguments),
        j      = i;
    
    while (j--) {
      result = fns[j].call(null, result);
    }
    
    return result;
  };
};

var getContents = function(el) {
  return el.innerHTML;
};

var zip = function(fst, snd) {
  var zipped = [];
  
  for (i = 0; i < fst.length; i++)
    zipped[i] = [fst[i], snd[i]];
  
  return zipped;
};

var maximum = function(values) {
  return values.reduce(function(m, n) { return Math.max(n, m); }, 0);
};

var HistogramFromTable = function(wrapper) {
  this.X       = 40;
  this.Y       = 20;
  this.GUTTER  = 2;
  this.TOP     = 27;
  this.BOTTOM  = 4;
  this.SIDE    = 9;
  
  this.table   = jQuery(wrapper).find('table').eq(0).hide();
  var rows     = this.table.find('tr');
  
  this.keys    = jQuery.makeArray(rows.eq(0).find('td.month'))
                 .map(getContents);
  this.values  = jQuery.makeArray(rows.eq(1).find('td.num_books'))
                 .map(compose(parseInt, getContents));
  
  var width  = (this.X + this.GUTTER) * this.values.length - this.GUTTER + this.SIDE * 2,
      height = maximum(this.values) * this.Y + this.TOP + this.BOTTOM;
  
  this.canvas  = jQuery('<canvas width="' + width + '" height="' + height + '"></canvas>');
  this.context = this.canvas[0].getContext('2d');
  
  var striped = new Image();
  striped.src = '/images/stripes.png';
  var self    = this, pattern;
  
  this.table.after(this.canvas);
  
  this.insertBar = function(size, order) {
    var x = order * (this.X + this.GUTTER) + this.SIDE,
        y = this.Y * size;
    
    var offset = this.canvas.attr('height') - y - this.BOTTOM;
    
    this.context.fillStyle = '#272c2e';
    this.context.fillRect(x, offset, this.X, y);
    
    var label = jQuery('<span class="key">' + this.keys[order] + '</span>');
    label.css({
      width: this.X,
      top:   this.canvas.attr('height') + 8 - this.BOTTOM,
      left:  x
    });
    this.table.after(label);
    
    this.context.fillStyle = '#212426';
    for (i = 1; i < size; i++) {
      this.context.fillRect(order * (this.X + this.GUTTER) + this.SIDE,
        offset + i * this.Y, this.X, 1);
    }
  };
  
  jQuery(striped).load(function() {
    self.context.fillStyle = self.context.createPattern(striped, 'repeat');
    self.context.fillRect(0, 0, width, height - self.BOTTOM);
    
    self.values.forEach(self.insertBar, self);
    
    self.context.fillStyle = '#2b3033';
    self.context.fillRect(0, self.canvas.attr('height') + 3 - self.BOTTOM,
      self.canvas.attr('width'), 1);
  });
};
