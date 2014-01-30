$(document).on('click', '.follow-btn', function() {
    var _this = $(this);
    var id_name = _this.parents('.post-div').attr('id');
    var post_type = get_post_type(id_name);
    var post_id = get_post_id(id_name);
    var data = {};
    data[post_type] = post_id;
    _this.addClass('disabled')

    $.ajax({
        url: '/main/follow/toggle',
        type: 'POST',
        dataType: 'json',
        data: data,
        success: function(data){
            

        }
    })

    if (_this.hasClass('active')) {
        _this.removeClass('active').children('i').removeClass('icon-white')
    }
    else {
        _this.addClass('active').children('i').addClass('icon-white')
    }
    _this.removeClass('disabled')


})
