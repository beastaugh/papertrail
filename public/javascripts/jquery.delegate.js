(function($) {

    $.fn.delegate = function(eventType, rules) {

        var makeArgs = function(args, el) {
            var args = $.makeArray(args);
            args.length < 2 ? args.push(el) : args.splice(1, 0, el);
            return args;
        };

        // In IE reset/submit do not bubble.
        // Safari 2 submit does not bubble.
        if (($.browser.msie && /reset|submit/.test(eventType))
            || ($.browser.safari && parseInt($.browser.version) < 500 && eventType == 'submit')) {

            if (eventType == 'reset') {
                // reset:
                // click [type=reset]
                // press escape [type=text], [type=password], textarea
                this.bind('click', function(e) {
                    for (var selector in rules) {
                        var $target = $(e.target);
                        if ($target.is('[type=reset]')
                            && $(e.target.form).is(selector)) {

                            arguments[0] = $.event.fix(e);
                            arguments[0].target = e.target.form;
                            arguments[0].type = eventType;
                            var ret = rules[selector].apply(this, makeArgs(arguments, e.target.form)); // required if confirm() is involved
                            return ret;
                        }
                    }
                });
                this.bind('keypress', function(e) {
                    for (var selector in rules) {
                        var $target = $(e.target);
                        if ($target.is('[type=text], [type=password], textarea')
                            && $(e.target.form).is(selector)
                            && e.keyCode == 27) {

                            arguments[0] = $.event.fix(e);
                            arguments[0].target = e.target.form;
                            arguments[0].type = eventType;
                            var ret = rules[selector].apply(this, makeArgs(arguments, e.target.form)); // required if confirm() is involved
                            return ret;
                        }
                    }
                });
            }

            if (eventType == 'submit') {
                // submit:
                // click [type=submit], [type=image]
                // press enter [type=text], [type=password], textarea
                this.bind('click', function(e) {
                    for (var selector in rules) {
                        var $target = $(e.target), form;
                        if (($target.is('[type=submit], [type=image]')
                            || ($target = $(e.target).parents('[type=submit], [type=image]')) && $target.length)
                            && $((form = $target[0].form)).is(selector)) {

                            arguments[0] = $.event.fix(e);
                            arguments[0].target = form;
                            arguments[0].type = eventType;
                            var ret = rules[selector].apply(this, makeArgs(arguments, form)); // required if confirm() is involved
                            return ret;
                        }
                    }
                });
                this.bind('keypress', function(e) {
                    for (var selector in rules) {
                        var $target = $(e.target);
                        if ($target.is('[type=text], [type=password], textarea')
                            && $(e.target.form).is(selector)
                            && e.keyCode == 13) {

                            arguments[0] = $.event.fix(e);
                            arguments[0].target = e.target.form;
                            arguments[0].type = eventType;
                            var ret = rules[selector].apply(this, makeArgs(arguments, e.target.form)); // required if confirm() is involved
                            return ret;
                        }
                    }
                });
            }

            return this;
        }

        return this.bind(eventType, function(e) {
            for (var selector in rules) {
                var $target = $(e.target);
                if ($target.is(selector) || ($target = $target.parents(selector)) && $target.length)
                    return rules[selector].apply(this, makeArgs(arguments, $target[0]));
            }
        });
    };

})(jQuery);