/* IE doesnt have console object. */
/* So you call "console.log()" method, */
/* IE raise erroe. */
/* This script prevent it.*/

$(function(){
  if(typeof console == "undefined"){
    console = {
      log:function(){},
      debug:function(){},
      info:function(){},
      warn:function(){},
      error:function(){},
      assert: function(){}
    };
  }else{
    console.log("I'm a script, named 'dummy_console_for_ie6.js'.");
    console.log("OK. This browser has console.");
  }
});
