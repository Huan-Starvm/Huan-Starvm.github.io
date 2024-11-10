<?php
class Components_Ssh {
    private $host;
    private $user;
    private $pass;
    private $port;
    private $conn = false;
    private $error;
    private $stream;
    private $stream_timeout = 100;
    private $log;
    private $lastLog;
    private $sLog;
 
    public function __construct ( $host, $user, $pass, $port, $serverLog ) {
        $this->host = $host;
        $this->user = $user;
        $this->pass = $pass;
        $this->port = $port;
        $this->sLog = $serverLog;
 
        if ( $this->connect ()->authenticate () ) {
            return true;
        }
    }
 
    public function isConnected () {
        return ( boolean ) $this->conn;
    }
 
    public function __get ( $name ) {
        return $this->$name;
    }
 
    public function connect () {
        $this->logAction ( "正在链接 -> {$this->host}" );
        if ( $this->conn = ssh2_connect ( $this->host, $this->port ) ) {
            return $this;
        }
        $this->logAction ( "链接失败 -> {$this->host}" );
        //exit ( "Unable to connect to {$this->host}" );
    }
 
    public function authenticate () {
        $this->logAction ( "正在认证 -> {$this->host}" );
        if ( ssh2_auth_password ( $this->conn, $this->user, $this->pass ) ) {
            return $this;
        }
        $this->logAction ( "认证失败 -> {$this->host} failed" );
        //exit ( "Unable to authenticate to {$this->host}" );
    }
  
    public function cmd ( $cmd, $returnOutput = false ) {
        $this->logAction ( "执行命令 -> $cmd" );
        $this->stream = ssh2_exec ( $this->conn, $cmd );
 
        if ( FALSE === $this->stream ) {
            $this->logAction ( "执行失败 -> $cmd" );
            //exit ( "Unable to execute command '$cmd'" );
        }
        $this->logAction ( "执行成功 -> $cmd" );
 
        stream_set_blocking ( $this->stream, true );
        stream_set_timeout ( $this->stream, $this->stream_timeout );
        $this->lastLog = stream_get_contents ( $this->stream );
 
        $this->logAction ( "命令输出 -> [$cmd]:{$this->lastLog}" );
        fclose ( $this->stream );
        $this->log .= $this->lastLog . "\n";
        return ( $returnOutput ) ? $this->lastLog : $this;
    }
 
    public function shellCmd ( $cmds = array () ) {
        $this->logAction ( "虚拟终端 -> 终端已打开" );
        $this->shellStream = ssh2_shell ( $this->conn );
        sleep ( 1 );
        $out = '';
        while ( $line = fgets ( $this->shellStream ) ) {
            $out .= $line;
        }
 
        $this->logAction ( "虚拟终端 -> [输出]:$out" );
 
        foreach ( $cmds as $cmd ) {
            $out = '';
            $this->logAction ( "执行命令 -> $cmd" );
            fwrite ( $this->shellStream, "$cmd" . PHP_EOL );
            sleep ( 1 );
            while ( $line = fgets ( $this->shellStream ) ) {
                $out .= $line;
                sleep ( 1 );
            }
            $this->logAction ( "命令输出 -> [$cmd]:$out" );
        }
 
        $this->logAction ( "虚拟终端 -> 终端已关闭" );
        fclose ( $this->shellStream );
    }
 
    public function getLastOutput () {
        return $this->lastLog;
    }
 
    public function getOutput () {
        return $this->log;
    }
 
    public function disconnect () {
        $this->logAction ( "正在断开 -> {$this->host}" );
        // if disconnect function is available call it..
        if ( function_exists ( 'ssh2_disconnect' ) ) {
            ssh2_disconnect ( $this->conn );
        }
        else { // if no disconnect func is available, close conn, unset var
            @fclose ( $this->conn );
            $this->conn = false;
        }
        // return null always
        return NULL;
    }
    
    public function logAction ( $message ) {
    	if ( $this->sLog == 'true' ) {
    		$this->lastLog = $this->log;
    		$this->log = $message;
    		//echo $message .'<br>';
    	}
    }
}