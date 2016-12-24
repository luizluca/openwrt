#!/usr/bin/awk -f
#
#
BEGIN {
	split("SPI_COMMAND_BUFFER_ALLOCATE SPI_COMMAND_BUFFER_FREE SPI_COMMAND_SET_SPI_CONFIG SPI_COMMAND_SET_DELAY SPI_COMMAND_READ SPI_COMMAND_WRITE", spi_command, " ")
	split("RALINK_GPIO_SET_DIR RALINK_GPIO_READ RALINK_GPIO_WRITE RALINK_GPIO_READ_BIT RALINK_GPIO_WRITE_BIT RALINK_GPIO_READ_BYTE RALINK_GPIO_WRITE_BYTE RALINK_GPIO_ENABLE_INTP RALINK_GPIO_DISABLE_INTP RALINK_GPIO_REG_IRQ RALINK_GPIO_SET_DIR_IN RALINK_GPIO_SET_DIR_OUT RALINK_GPIO_SET RALINK_GPIO_CLEAR RALINK_GPIO_LED_SET SYSIF_READ SYSIF_WRITE", gpio_req, " ")

	split("SYSINFO_MODEL SYSINFO_COMPANY SYSINFO_VERSION SYSINFO_DATE SYSINFO_MODEL_DESC SYSINFO_COMPANY_URL SYSINFO_HW_VERSION SYSINFO_ROM_VERSION SYSINFO_SERVER_STATUS SYSINFO_PROTOCOL USER1_SIG_FLAG USER2_SIG_FLAG USER_SIG_PID ETHERNET_LINK ETHERNET_SPEED ETHERNET_DUPLEX FRAME_LIST_INIT FRAME_READY_LIST_Q FRAME_GET_IMAGE FRAME_RELEASE_IMAGE FRAME_BUFFER_SIZE FRAME_VIDEO_SIZE WIRELESS_SUPPORT PTZ_SUPPORT MAC_ADDRESS FTP_TEST_RESULT EMAIL_TEST_RESULT DDNS_STATUS UPNP_IP CURRENT_IP CURRENT_SUBNET_MASK CURRENT_DEFAULT_GATEWAY CURRENT_DNS1 CURRENT_DNS2 WLAN_LINK_STATUS WLAN_LINK_SSID WLAN_LINK_AP_MAC WLAN_LINK_CHANNEL WLAN_LINK_TX_RATE WLAN_LINK_ENCRYPTION DOWNLOAD_STATUS DOWNLOAD_MESSAGE START_SITE_SURVEY GET_SITE_SURVEY WIRELESS_ON_OFF DDNS_MESSAGE ACTIVE_USER_TABLE ADD_ACTIVE_USER GET_ACTIVE_USER DEL_ACTIVE_USER ACTIVE_USER_AUDIO_ON ACTIVE_USER_AUDIO_OFF LED_CONTROL QUEUE_AUDIO_DATA ACTIVE_USER_KEEP_ALIVE READ_EVENT_FLAG SET_EVENT_FLAG CLEAR_EVENT_FLAG PPPOE_IP PPPOE_SUBNET_MASK SYSINFO_VERSION_BUILD MOTION_DETECTION_STATUS SET_MAC_ADDRESS BOOTINFO_SIGNATURE LED_OPERATION REBOOT_TIME SET_QC_TEST WLAN_CHANNEL_LIST COUNTRY_REGION ACTIVE_USER_NUMBER PORT_FORWARDING_STATUS MANUAL_FTP_EMAIL_STATE SET_DAY_NIGHT_MODE IR_LED_ON_OFF WLAN_ALC SET_EMAIL_FRAME_TIME EMAIL_GET_QUEUE_FRAME PPPOE_STATE WEB_LANGUAGE AUTO_IP DHCP_STATE CLEAR_UBOOT_PARAMETER SPI_LOCK_UNLOCK SPI_LOCK_UNLOCK_GETFILE SPI_LOCK_UNLOCK_LISTFILE H264_LIST_INIT H264_READY_LIST_Q H264_GET_IMAGE H264_RELEASE_IMAGE H264_BUFFER_SIZE H264_VIDEO_SIZE H264_HTTP_LIVE_STREAM H264_GETSET_FFMPEG_PID SOUND_DB CIFS_TEST_RESULT SOUND_DETECTION_STATUS STOP_AVI_RECORD DST_TIME SEMAPHORE_GETSET SEMAPHORE_CLEAR", sysif, " ")
}


/^open\(/ && /\/dev\/spiS0/ { FD_SPI=$(NF) }
/^open\(/ && /\/dev\/gpio/ { FD_GPIO=$(NF) }

/^read\(/ {
	$0=gensub(/(^read\([[:digit:]]+, ").*(", [[:digit:]]+\).*)/,"\\1...<ommited>...\\2","1",$0)
}

/^ioctl\(/ { $0=gensub(/FIBMAP/, "_IOC(0, 0, 1, 0)", "1", $0) } 
/^ioctl\(.*, _IOC\(/ {
	ioc=$0
	ioc=gensub(/(.*)(_IOC\([^)]*\))(.*)/,"\\2","1",ioc)
	for (i=split(ioc, octects, ", "); i>0; i--) {
		octects[i]=strtonum(octects[i])
	}
	cmd=or(lshift(octects[1],30), lshift(octects[2],8), lshift(octects[3],0), lshift(octects[4],16))
	arg=strtonum(gensub(/(.*)(_IOC\([^)]*\)), ([[:digit:]a-fx]+).*/,"\\3","1",$0))
	arg_info=sprintf("0x%x",arg)
}

$0 ~ "^ioctl\\(" FD_SPI "," {
	$0=gensub(/(.*)(_IOC\([^)]*\))(.*)/,"\\1" spi_command[cmd] "\\3","1",$0)
	#if (spi_command[cmd] ~ /^SPI_COMMAND_SET_SPI_CONFIG/) {
	#	$0 = $0 " ### (in kernel) CPU_REG(SPI_CFG_REG) = " arg_info
	#}
}

$0 ~ "^ioctl\\(" FD_GPIO "," {
    # idx = (req >> RALINK_GPIO_DATA_LEN) & 0xFFL;    //used for ralink_gpio functions
    # req &= RALINK_GPIO_DATA_MASK;
	idx=and(rshift(cmd,24),0xFFL)
	req=and(cmd, 0x0000001F)

	idx_info=sprintf("0x%x",idx)

	if ((gpio_req[req] == "SYSIF_READ") || (gpio_req[req] == "SYSIF_WRITE")) {
	    # idx = (cmd >> SUBCMD_IDX_SHIFT) & 0xFFL;     //8bit
   		# buf_len = (cmd >> BUF_LEN_SHIFT) & 0x7FFFFL; //19bit
		idx=and(rshift(cmd,5),0xFFL)
		idx_info=sysif[idx] "/" sprintf("0x%x",idx)
	}
	if (gpio_req[req] ~ /RALINK_GPIO_(READ|WRITE)_BIT/) {
		idx_info = "p" idx "/" idx_info
	}
	if (gpio_req[req] ~ /RALINK_GPIO_SET_DIR_(IN|OUT)/) {
		x=arg
		pins=""
		for (i=0;x>0;i++) {
			if (and(x,0x1l))
				pins = pins " | p" i 
			x=rshift(x,1)
		}
		arg_info = "[ " substr(pins,4) " ]/" arg_info
	}

	$0=gensub(/(.*)(_IOC\([^)]*\)), ([[:digit:]a-fx]+)(.*)/,"\\1" "[ req=" gpio_req[req] "/" sprintf("0x%x",req) ", idx=" idx_info " ], " arg_info "\\4","1",$0)
#	$0=gensub(/(.*)(_IOC\([^)]*\))([[:digit:]a-fx]+)(.*)/,"\\1" "[ req=" gpio_req[req] "/" sprintf("0x%x",req) ", idx=" idx_info " ]"  "\\3\\4","1",$0)

}

{ print }

