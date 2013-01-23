/* When user close browser's tab, */
/* browser (this script) will say "Do you really want to close?" or somehing */

/* Available on almost PC browser */
/* Not available on iOS*/

$(function(){
    $(window).bind("beforeunload", function(e){return "";});
});

