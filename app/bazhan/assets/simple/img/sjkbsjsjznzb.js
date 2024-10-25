$("#info_alert").hide();
$("#main2").hide();
var main = true;
$('#info').click(function () {
	if(main==true){
		$("#info_alert").show(500);
	}else{
		$("#info_mess").attr("class","alert alert-info alert-dismissable");
		$("#info_mess").html("正在刷新资源列表...");
		$.ajax({
			type : "GET",
			url : "ajax.php",
			dataType : 'json',
			success : function(data) {
				if(data.code == 1){
					if(data.data&&data.data.length>0){
						$("#info_mess").attr("class","alert alert-success alert-dismissable");
						$("#info_mess").html(data.msg);
						$("#table").empty();
						for (i = 0; i < data.data.length; i++) {
							var ii=i+1;
							$("#table").append("<tr><td><a class=\"btn btn-xs btn-danger btn-rounded\" href=\"javascript:void(0);\">"+ii+"</a></td><td>"+data.data[i]+"</td><td><a class=\"btn btn-xs btn-warning btn-rounded\" href=\"http://wget.moleft.cn/down/"+data.data[i]+"\">下载</a></td></tr>");
						}
					}else{
						$("#info_mess").attr("class","alert alert-warning alert-dismissable");
						$("#info_mess").html(data.msg);
					}
				}else{
					$("#info_mess").attr("class","alert alert-danger alert-dismissable");
					$("#info_mess").html(data.msg);
				}
			} 
		});
	}
});
$('#list').click(function () {
	if(main==true){
		main = false;
		$("#main").hide(250);
		$("#main2").show(250);
		$("#list").html("<i class=\"fa fa-chevron-circle-left\">&nbsp;在线扒站");
		$("#info").html("<i class=\"fa fa-refresh\">&nbsp;刷新列表");
		$("#title").html("<i class=\"fa fa-folder-open\"></i>&nbsp;&nbsp;<b>已扒资源</b>");
		$.ajax({
			type : "GET",
			url : "ajax.php",
			dataType : 'json',
			success : function(data) {
				if(data.code == 1){
					if(data.data&&data.data.length>0){
						$("#info_mess").attr("class","alert alert-success alert-dismissable");
						$("#info_mess").html(data.msg);
						$("#table").empty();
						for (i = 0; i < data.data.length; i++) {
							var ii=i+1;
							$("#table").append("<tr><td><a class=\"btn btn-xs btn-danger btn-rounded\" href=\"javascript:void(0);\">"+ii+"</a></td><td>"+data.data[i]+"</td><td><a class=\"btn btn-xs btn-warning btn-rounded\" href=\"http://wget.moleft.cn/down/"+data.data[i]+"\">下载</a></td></tr>");
						}
					}else{
						$("#info_mess").attr("class","alert alert-warning alert-dismissable");
						$("#info_mess").html(data.msg);
					}
				}else{
					$("#info_mess").attr("class","alert alert-danger alert-dismissable");
					$("#info_mess").html(data.msg);
				}
			} 
		});
	}else{
		main = true;
		$("#main2").hide(250);
		$("#main").show(250);
		$("#list").html("<i class=\"fa fa-folder-open\">&nbsp;已扒资源");
		$("#info").html("<i class=\"fa fa-question-circle\">&nbsp;扒站说明");
		$("#title").html("<i class=\"fa fa-linux\"></i>&nbsp;&nbsp;<b>在线扒站</b>");
	}
	
});
$('#submit').click(function () {
		var url=$("input[name='url']").val()
		if ($(this).attr("data-lock") === "true") return;
		if(url==''){alert('你啥都不输入我怎么扒！');return false;}
		$("#running_class").attr("class","alert alert-warning alert-dismissable");
		$("#running_class").text("正在扒取站点："+url);
		$("#running_alert").show();
		$("#submit").attr('disabled',true);
		$("#url").attr('disabled',true);
		$.ajax({
			type : "POST",
			url : "ajax.php",
			data : {url:url},
			dataType : 'json',
			success : function(data) {
				//layer.close(ii);
				$("#submit").attr('disabled',false);
				$("#url").attr('disabled',false);
				if(data.code == 1){
					$("#running_class").attr("class","alert alert-success alert-dismissable");
					$("#running_class").html(data.msg+" <a class=\"btn btn-xs btn-danger btn-rounded\" href=\""+data.down+"\">点我下载</a>");
					$("#running_alert").show();
				}else{
					$("#running_class").attr("class","alert alert-danger alert-dismissable");
					$("#running_class").text(data.msg);
					$("#running_alert").show();
				}
			}
		});
});