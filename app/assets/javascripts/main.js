$(document).ready(function() {
	$('.ask-btn').modal({
		show: false
	});
    // register listeners for sort links
    $('#sort-popular').bind("click", sort_popular);
    $('#sort-recent').bind("click", sort_recent);
    $('#sort-follow').bind("click", sort_follow);
    $('#new-question-ask-btn').bind("click", answer_form_validate_and_submit);
});

// Requires: users to log in
// Modifies: nothing
// Effects: fetch a specific page sorted by key word popular
var sort_popular = function () {
    var url = controller_prefix + "/sort"+"?by=popular&page=1";
    $('#sort-recent').removeClass('active');
    $('#sort-follow').removeClass('active');
    $('#sort-popular').addClass('active');
    $.ajax({
        url: url,
        success: function(data) {
            var html = data['html'];
            if (html === " " ) {
              html = "There are currently no questions on this topic. <a href='#question-form' data-toggle='modal'>Ask one</a> now!";
            }
            $('#question-display').html(html);
        },
        dataType: "json" });

}

// Requires: users to log in
// Modifies: nothing
// Effects: fetch a specific page sorted by key word recent
var sort_recent = function () {
    var url = controller_prefix + "/sort"+"?by=recent&page=1";
    $('#sort-recent').addClass('active');
    $('#sort-follow').removeClass('active');
    $('#sort-popular').removeClass('active');
    $.ajax({
        url: url,
        success: function(data) {
            var html = data['html'];
            if (html === " " ) {
              html = "There are currently no questions on this topic. <a href='#question-form' data-toggle='modal'>Ask one</a> now!";
            }
            $('#question-display').html(html);
        },
        dataType: "json" });
}

// Requires: users to log in
// Modifies: nothing
// Effects: fetch a specific page sorted by key word follow
var sort_follow = function () {
    var url = controller_prefix + "/sort"+"?by=follow&page=1";
    $('#sort-recent').removeClass('active');
    $('#sort-follow').addClass('active');
    $('#sort-popular').removeClass('active');
    $.ajax({
        url: url,
        success: function(data) {
            var html = data['html'];
            if (html === " ") {
                html = "You are not currently following any questions on this topic."
            }
            $('#question-display').html(html);
        },
        dataType: "json" });
}

// Requires: users to log in
// Modifies: Question
// Effects: validates a question form and submit it if successful
var answer_form_validate_and_submit = function() {
    var form = document.forms['new_question'];
    var tags = form['hashtag'].value;
    var tagsArray = tags.split(/#/g)
    var processed = []
    for (var i = 0; i < tagsArray.length; i++) {
        // not empty string
        if (tagsArray[i].length > 0) {
           var tag = tagsArray[i].trim();
           if (tag.length > 0){
              processed.push(tag);
           }
        }
    }
    if (processed.length > 0 && processed.length <= 5) {
       var s = processed.join(' ');
       $('#hashtag').val(s);
       form.submit();
    } else {
       alert("false");
    }
 };
