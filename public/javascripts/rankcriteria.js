$(function () {
    $('#SuggestedPhases ul li').css({
        cursor: 'pointer'
    }).mouseover(function() {
        $(this).css({
            backgroundColor: '#f6f6f6'
        });
    }).mouseout(function(){
           $(this).css({
            backgroundColor: 'White'
        });
    }).click(function() {
       $('input[type="text"]').val($(this).html());
    });
});