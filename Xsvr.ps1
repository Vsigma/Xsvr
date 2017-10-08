Function f2{ param([string]$RequestString = "") [psobject] $obj = New-Object psobject
	Add-Member -InputObject $obj -Force -MemberType NoteProperty -Name Version		-Value "HTTP/1.1"
	Add-Member -InputObject $obj -Force -MemberType NoteProperty -Name Command		-Value ""
	Add-Member -InputObject $obj -Force -MemberType NoteProperty -Name ResourceName		-Value ""
	Add-Member -InputObject $obj -Force -MemberType NoteProperty -Name Arguments		-Value (New-Object System.Collections.Hashtable)
	if($RequestString -eq ""){return}
	[psobject] $WebRequest = $obj; $ndx = $RequestString.IndexOf( " " ); $WebRequest.Command = $RequestString.SubString( 0, $ndx ).Trim()
	$RequestString = $RequestString.SubString( $ndx ).Trim(); $ndx = $RequestString.IndexOf( " " ); if( $ndx -gt 0 ){
		$WebRequest.ResourceName = $RequestString.SubString( 0, $ndx ).Trim(); $ndx = $RequestString.IndexOf("`r`n`r`n");
		if($ndx -gt 0){ Add-Type -Asse System.Web
			$tps = [System.Web.HttpUtility]::UrlDecode($RequestString.SubString($ndx+7), [System.Text.Encoding]::UTF8);
			Set-Content \b.txt $tps} $ndx = $WebRequest.ResourceName.IndexOf("?"); 
		if($ndx -gt 0){ $s = $WebRequest.ResourceName; $WebRequest.ResourceName = $s.SubString(0, $ndx); $tar = $s.SubString($ndx+1);
			foreach( $s in $tar.Split( "&" ) ){ $ndx = $s.IndexOf( "=" ); if( $ndx -lt 0 ){ $WebRequest.Arguments.Add( $s, "" )
				}else{ $WebRequest.Arguments.Add( $s.Substring( 0, $ndx ), $s.Substring( $ndx + 1 ) ) }	} }
		$WebRequest.ResourceName = $WebRequest.ResourceName.Replace( "%20", " ").Replace( "/", "\").Trim( " \" ) }
	if( $RequestString -match "(HTTP/.+)" )	{ $WebRequest.Version = $matches[0] }
	Write-Host "$($WebRequest.ResourceName), Arg $($WebRequest.Arguments.Count)"; return $WebRequest}
Function f1{ $Listener = [System.Net.Sockets.TcpListener]80;$Listener.Start(); $Status = "OK"; while( $Status -eq "OK" ){
		if( $host.ui.rawui.KeyAvailable ){ $Status = "Shutdown"
		}elseif( $Listener.Pending() ){ $Socket = $Listener.AcceptSocket(); if( $Socket.Available ){ $RequestString = ""; 
				$Socket.ReceiveTimeout = 10000;	[byte[]] $brv = new-object byte[] $tbf; while($Socket.Available){
					$brc = 0; $brc = $Socket.Receive($brv, $brv.Length, 0); "= $brc ="
					$RequestString+= [Text.Encoding]::ASCII.GetString( $brv, 0, $brc )
				} $ndx = $RequestString.IndexOf($null); if( $ndx -ge 0 ){ $RequestString = $RequestString.SubString( 0, $ndx ) }
				(f2 $RequestString).Command; $cnt = $Socket.Send( $trd )			
			} if( ($Socket -ne $null) -and $Socket.Connected ) { $Socket.Close() }
		}else{ Start-Sleep -milli 1 } } 	$Listener.Stop() ;Write-Host "Server stopped." }
$trd = Get-Content -Path "d:/a.htm" -Encoding byte -TotalCount -1 -ReadCount 0;$tbf = 1024;cls;f1