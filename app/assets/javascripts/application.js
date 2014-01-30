// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
//= require jquery.ui.all

$(document).ready(function() {
    // registers handler for auto-complete for search box
    auto_complete_search_box();
    $('.confirm-delete').modal({
    	show:false
    })
});

$(document).on('click', '.vote-btn', function() {
	var _this = $(this);
	//_this.addClass('disabled');
	var action = get_post_action(_this);
	var id_name = _this.closest('.post-div').attr('id');
	var post_type = get_post_type(id_name);
	var post_id = get_post_id(id_name);
	var data = {};
	data[post_type+'_id'] = post_id;
	var vote_btns = _this.closest('.post-div').find('.vote-btn');

	// boolean: whether post had previously been voted
	var was_voted = _this.hasClass('active');
	var new_score = get_new_score(_this);

	// remove highlighting from both buttons
	vote_btns.each(function(i) {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active').children("i").removeClass('icon-white');
		}
	});

	// highlight clicked button if wasn't highlighted previously
	if (was_voted === false) {
		_this.addClass('active').children("i").addClass('icon-white');
	}

	// update the score
	_this.closest('.post-div').find('.score').text(new_score)		

	//ajax request to upvote/downvote url
	$.ajax({
		url: action,
		type: 'POST',
		dataType: 'json',
		data: data,
		success: function(data){
			_this.removeClass('disabled');
		}
	})
})

// retrieve the action path associated with the jQuery element
// requires: jQuery button
var get_post_action = function(element) {
	return element.attr('action');
}

// returns the type of post contained inside the div
// requires: the ID of a div containing a post
var get_post_type = function(id_name) {
	// e.g. 'a_23'
	if (id_name[0] === 'a') {
		return 'answer'
	} else { // e.g. 'q_23'
		return 'question'
	}
}

var get_post_id = function(id_name) {
	return id_name.substring(2);
}

// fetches the current score of the post from the DOM and returns a new score
// according to which vote button was pressed and whether or not the post had 
// previously been voted
// requires: a jQuery element representing the vote button that was pressed,
//			the DOM has been loaded
var get_new_score = function(vote_btn_ele) {
	var _this = vote_btn_ele;
	var up = _this.closest('.vote').find('.up').first();
	var down = _this.closest('.vote').find('.down').first();
	var new_score = parseInt(_this.closest('.vote').find('.score').first().text());

	if ((up.hasClass('active') === false) && (down.hasClass('active') === false)) {
		if (_this.hasClass('up')) {
			new_score += 1;
		} else {
			new_score -= 1;
		}
	} else if (up.hasClass('active')) {
		if (_this.hasClass('up')) {
			new_score -= 1;
		} else {
			new_score -= 2;
		}
	} else if (down.hasClass('active')) {
		if (_this.hasClass('up')) {
			new_score += 2;
		} else {
			new_score += 1;
		}
	}
	return new_score;
}


// when "edit post" button is clicked, reveal edit form
// and hide regular content
$(document).on('click', '.edit-post', function() {
	var _this = $(this);
	var parent_post = _this.closest('.post-div');
	var post_content_div = parent_post.find('.post-content');
	var edit_form = parent_post.find('.edit-post-form')
	post_content_div.hide();
	edit_form.show();
})

// when "delete" confirmation button is clicked, delete the answer
// fade out the answer and display a message to the user
$(document).on('click', '.delete-answer-btn', function(e) {
	var _this = $(this);
	var parent_post  = _this.closest('.post-div');
	$.ajax({
		url: get_post_action(_this),
		type: 'POST',
		dataType: 'json',
		success: function(data) {
			$('.modal').modal('hide');
			parent_post.hide().html("Your answer has been deleted").fadeIn();
		}
	})
})

// when 'save' button is clicked while editing a question/answer
// update post on the server and replace content with new text
$(document).on('click', '.update-post', function(e) {
	e.preventDefault();
	var _this = $(this);
	var parent_post = _this.closest('.post-div');
	var post_type = get_post_type(parent_post.attr('id'));
	
	var post_form = parent_post.find('.edit-post-form');
	_this.addClass('disabled');
	
	if (post_type === 'answer') {
		var new_text = post_form.children('textarea[name="answer[content]"]').val();
		parent_post.find('.answer-content').html(new_text);
	}

	else {
		var new_title = post_form.children('textarea[name="question[title]"]').val();
		var new_details = post_form.children('textarea[name="question[details]"]').val();
		parent_post.find('.question-title').html(new_title);
		parent_post.find('.question-details').html(new_details);
	}

	$.ajax({
		url: get_post_action(_this),
		type: 'POST',
		dataType: 'json',
		data: post_form.serialize(),
		success: function(data) {
			parent_post.find('.post-content').show();
			parent_post.find('.edit-post-form').hide();
			_this.removeClass('disabled');
		}

	})
})

// when "cancel" button on edit question/answer form is clicked
// hide form and displays content in original state
$(document).on('click', '.cancel-update', function(e) {
	e.preventDefault();
	var _this = $(this);
	var parent_post = _this.closest('.post-div');
	var post_content_div = parent_post.find('.post-content');
	var edit_form = parent_post.find('.edit-post-form')
	edit_form.hide();
	post_content_div.show();
})

