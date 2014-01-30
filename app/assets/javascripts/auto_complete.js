
// adds auto-complete feature to search box in the nav bar
var auto_complete_search_box = function () {
    var question_titles = [];
    var action = "/main/question_titles"
    $.ajax({
        url: action,
        type: 'GET',
        dataType: 'json',
        success: function(data){
            for(var i= 0; i < data.length; i++){
                question_titles.push({label :data[i]['title'], id : data[i]['id']});
            }
            $( "#query" ).autocomplete({
                source: question_titles,
                minLength: 1,
                select: function(event, ui) {
                    window.location = ('/main/questions/' + ui.item.id);

                }
            });
        }
    })
}


// adds auto-complete feature to hashtags in creating a question
// reference: http://jsfiddle.net/LHNky/
var auto_complete_hashtags = function () {
    $("#hashtag")
        // don't navigate away from the field on tab when selecting an item
            .bind("keydown", function(event) {
                if (event.keyCode === $.ui.keyCode.TAB && $(this).data("autocomplete").menu.active) {

                    event.preventDefault();
                }
            }).autocomplete({
                source: function(request, response) {
                    if (request.term.indexOf("#") >= 0) {
                        getTags(extractLast(request.term), function(data) {
                            response($.map(data, function(el) {
                                return {
                                    value: el.name
                                }
                            }));
                        });
                    }
                },
                focus: function() {
                    // prevent value inserted on focus
                    return false;
                },
                select: function(event, ui) {
                    var terms = split(this.value);
                    // remove the current input
                    terms.pop();
                    // add the selected item
                    terms.push(ui.item.value);
                    this.value = terms.join("#");
                    return false;
                }
            }).data("autocomplete")._renderItem = function(ul, item) {
        return $("<li>")
                .data("item.autocomplete", item)
                .append("<a>" + item.label + "</a>")
                .appendTo(ul);
    };

}

var split = function(val) {
    return val.split(/#\s*/);
}

var extractLast = function(term) {
    return split(term).pop();
}

var getTags = function(term, callback) {
    $.ajax({
        url: "/main/hashtag_names",
        data: {
            filter: term
        },
        type: "POST",
        success: callback,
        dataType: "json"
    });
}
