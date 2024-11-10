<?php
include "./common.php";
ignore_user_abort(true);
ini_set('max_execution_time', '0');
date_default_timezone_set('Asia/Shanghai');
@header('Content-Type: application/json; charset=UTF-8');

if (isset($_POST['url'])) {
    $url = $_POST['url'];
    $email = $_POST['email'];
    if (get_code($url) != 200) {
        exit(json_encode(array('code' => '-1', 'msg' => '扒站失败，请检查网址是否正确！'),JSON_UNESCAPED_UNICODE| JSON_PRETTY_PRINT));
    }
    $preg = "/^http(s)?:\\/\\/.+/";
    if(!preg_match($preg,$url)){
    		exit(json_encode(array('code' => '-1', 'msg' => '域名请带上协议头！如( http:// 或 https:// )'),JSON_UNESCAPED_UNICODE| JSON_PRETTY_PRINT));
    }
    $file = parse_url($url)['host'].'-'.mt_rand(10000,99999);
    $ssh = new Components_Ssh($host, $user, $pass, $port, $log);
    $ssh->cmd("bash /www/wwwroot/bazhan.mihoyo.nl/wget_site.sh {$url} {$file} >/dev/null && echo \"success\"");
    if(file_exists('./down/'.$file.'.zip')) {
    $content='扒站成功，请下载！下载链接https://bazhan.mihoyo.nl/down/' . $file . '.zip'. '预览https://bazhan.mihoyo.nl/work/' . $file . '/' . parse_url($url)['host'];
       $wz=$smtpapi."?adress=".$email."&isHTML=false&title=扒站成功&content=".$content;
       file_get_contents($wz);
       exit(json_encode(array('code' => '1', 'msg' => '扒站成功，请下载！', 'down' => 'https://bazhan.mihoyo.nl/down/' . $file . '.zip', 'yulan' => 'https://bazhan.mihoyo.nl/work/' . $file . '/' . parse_url($url)['host']),JSON_UNESCAPED_UNICODE| JSON_PRETTY_PRINT));
    } else {
        exit(json_encode(array('code' => '-1', 'msg' => '扒站失败，请联系作者！'),JSON_UNESCAPED_UNICODE| JSON_PRETTY_PRINT));
    }
} else {
function trans_byte($byte)

{

    $KB = 1024;

    $MB = 1024 * $KB;

    $GB = 1024 * $MB;

    $TB = 1024 * $GB;

    if ($byte < $KB) {

        return $byte . "B";

    } elseif ($byte < $MB) {

        return round($byte / $KB, 2) . "KB";

    } elseif ($byte < $GB) {

        return round($byte / $MB, 2) . "MB";

    } elseif ($byte < $TB) {

        return round($byte / $GB, 2) . "GB";

    } else {

        return round($byte / $TB, 2) . "TB";

    }

}
    $list = glob('./down/*.zip');
	$count = count($list);
    $page_num = isset($_GET['limit'])?$_GET['limit']:10;
    $pages = ceil($count / $page_num);
    $page = isset($_GET['page'])? $_GET['page']:1;
    $startpos = ($page - 1)*$page_num;
    $json['code'] = '0';
    $json['msg'] = '共获取到' . $count . '个资源！';
    $a = 0;
    foreach (array_slice($list, $startpos, $page_num) as $v) {
		$s = $a+1;
		$size=filesize($v);
		$time=date("Y-m-d H:i:s",filemtime($v));
    	$arr[$a] = ['id'=>$s,'name'=>str_replace('./down/', '', $v),'size'=>trans_byte($size),'time'=>$time];
	    $a++;
    }
    $json['count'] = $count;
    $json['data'] = $arr;
    exit(json_encode($json,JSON_UNESCAPED_UNICODE| JSON_PRETTY_PRINT));
}
function get_code($url){
  $ch = curl_init();
  $timeout = 3;
  curl_setopt($ch,CURLOPT_FOLLOWLOCATION,1);
  curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
  curl_setopt($ch, CURLOPT_HEADER, 1);
  curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
  curl_setopt($ch,CURLOPT_URL,$url);
  curl_exec($ch);
  return $httpcode = curl_getinfo($ch,CURLINFO_HTTP_CODE);
  curl_close($ch);
}
?>