// navbar affix
$( window ).resize(function() {
  $('#nav').affix({
      offset: {
        top: $('#nav').offset().top + 20
      }
  }); 
})
.resize();

if ($("#countdown").length > 0) {
  jQuery(document).ready(function(){	
    //var dateParts = $('#countdown').data("date") .match(/(\d+)-(\d+)-(\d+) (\d+):(\d+)/);
    
	dateFuture1 = new Date($('#countdown').data("date"))
	GetCount(dateFuture1, 'countdown');
  });
}	
function GetCount(ddate,iid){

    dateNow = new Date();	//grab current date
    amount = ddate.getTime() - dateNow.getTime();	//calc milliseconds between dates
    delete dateNow;

    // if time is already past
    if(amount < 0){
        document.getElementById(iid).innerHTML="";
    }
    // else date is still good
    else{
        days=0;hours=0;mins=0;secs=0;out="";

        amount = Math.floor(amount/1000);//kill the "milliseconds" so just secs

        days=Math.floor(amount/86400);
        if(days > 1) {amount=amount%(days*86400);}
        hours=Math.floor(amount/3600);
        amount=amount%3600;

        mins=Math.floor(amount/60);
        amount=amount%60;

        secs=Math.floor(amount);

        //if(hours != 0){out += "<span>" + hours +((hours==1)?"<br /><small>hour</small>":"<small>hours</small>")+"</span>";}
        out += "<span>" + days +((days==1)?"<br /><small>day</small>":"<small>days</small>")+"</span>";
        out += "<span>" + hours +((hours==1)?"<br /><small>hour</small>":"<small>hours</small>")+"</span>";
        out += "<span>" + mins +((mins==1)?"<small>min</small>":"<br /><small>mins</small>")+"</span>";
        out += "<span>" + secs +((secs==1)?"<small>sec</small>":"<br /><small>secs</small>")+"</span>";
        out = out.substr(0,out.length-2);
        document.getElementById(iid).innerHTML=out;

        setTimeout(function(){GetCount(ddate,iid)}, 1000);
    }
}
/*/ smoove
function close(a,b) {
    if(20 * Math.round(a/20) === 20 * Math.round(b/20)) return true;
}
$('.box-list>li, .fullrow .row>*').each( function() {
    if(close($(this).offset().left, $(this).parent().offset().left)) {
        $(this).data({move: '-100px,100px'});
    }
    else if(close($(this).offset().left + $(this).outerWidth(), $(this).parent().offset().left + $(this).parent().outerWidth())) {
        $(this).data({move: '100px,100px'});
    }
    else {
        $(this).data({moveY: '100px'});
    }
});
$('section, .box-list>li, .fullrow .row>*').smoove({offset: '10%'});

*/