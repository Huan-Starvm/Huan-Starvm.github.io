<?php
include "./common.php";
?>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title><?php echo $title?> </title>
  <link href="https://lib.baomitu.com/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://lib.baomitu.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
  <link rel="stylesheet" href="./assets/simple/css/plugins.css">
  <link rel="stylesheet" href="./assets/simple/css/main.css">
  <link rel="stylesheet" href="./assets/css/common.css">
  <script src="https://lib.baomitu.com/modernizr/2.8.3/modernizr.min.js"></script>
  <!--[if lt IE 9]>
    <script src="//lib.baomitu.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="//lib.baomitu.com/respond.js/1.4.2/respond.min.js"></script>
  <![endif]-->
  <style>
  div{filter:alpha(Opacity=98);-moz-opacity:0.98;opacity: 0.98;}
  </style>
</head>
<body><img src="https://t.mwm.moe/pc/" alt="Full Background" class="full-bg full-bg-bottom animation-pulseSlow" ondragstart="return false;" oncontextmenu="return false;">
<div class="col-xs-12 col-sm-10 col-md-8 col-lg-4 center-block " style="float: none;">
  <br /><br /><br />
    <div class="widget">
    <!--<div class="widget-content themed-background-flat text-center"  style="background-image: url(./assets/simple/img/userbg.jpg);background-size: 100% 100%;" >
<img  class="img-circle"src="https://q4.qlogo.cn/headimg_dl?dst_uin=2985639879&amp;spec=100" alt="Avatar" alt="avatar" height="60" width="60" />
<p></p>
    </div>-->

    <div class="block">
        <div class="block-title">
            <h2 id="title"><i class="fa fa-linux"></i>&nbsp;&nbsp;<b>在线扒站</b></h2>
        </div>
        <!-- 第一面板 -->
        <div id="main">
            <div class="input-group"><div class="input-group-addon"><span class="fa fa-globe"></span></div>
              <input type="text" id="url" name="url" value="" class="form-control" required="required" placeholder="请输入一个有效的网址"/>
              <input type="text" id="email" name="email" value="" class="form-control" required="required" placeholder="请输入一个有效的邮箱"/>
              </div><br/>
            <div class="form-group">
              <input id="submit" type="button" value="提交任务" class="btn btn-primary btn-block"/>
            </div>
            <hr>
            <div id="running_alert">
            	<div id="running_class" class="alert alert-info alert-dismissable">
					<!--<button type="button" class="close" onclick="$('#running_alert').hide(500);">&times;</button>-->
						任务队列未开始！ 本站服务器由星空云赞助提供！
				</div>
            </div>
            <div style="display: none" id="info_alert">
            	<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" onclick="$('#info_alert').hide(500);">&times;</button>
					本站是利用wget来扒站的，所以点击提交任务一直转圈是正常现象。<br>
					稍微等一会，就会收到扒站成功的提示，如果没有很久很久没有提示，再刷新页面。
				</div>
            </div>
            </div>
            
            </div>
			<hr>
			<div class="form-group">
			<a id="info" class="btn btn-info btn-rounded"><i class="fa fa-question-circle"></i>&nbsp;扒站说明</a>
		</div>
    </div>
  </div>
<script src="https://lib.baomitu.com/jquery/1.12.4/jquery.min.js"></script>
<script src="https://lib.baomitu.com/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="./assets/js/common.js"></script>
</body>
</html>