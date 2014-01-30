
var search = function() {
    var q = "/main/search"+"?q=" + $("#query").val();
    // redirect to search page
    window.location = q;
}

$(document).ready(function() {
    // bind listeners
    $('.search-btn').bind("click", search);
    $('#query').keypress(function(e) {
        if(e.which == 13) {
            search();
        }
    });
});

