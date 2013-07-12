###############################################################################
# GuardianAdmin.pl                                                            #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBB 2.4                                                    #
# Packaged:       April 12, 2009                                              #
# Distributed by: http://www.yabbforum.com                                    #
# =========================================================================== #
# Copyright (c) 2000-2009 YaBB (www.yabbforum.com) - All Rights Reserved.     #
# Software by:  The YaBB Development Team                                     #
#               with assistance from the YaBB community.                      #
# Sponsored by: Xnull Internet Media, Inc. - http://www.ximinc.com            #
#               Your source for web hosting, web design, and domains.         #
###############################################################################

$guardianadminplver = 'YaBB 2.4 $Revision: 1.6 $';
if ($action eq 'detailedversion') { return 1; }

&LoadLanguage('Guardian');

sub setup_guardian {
	&is_admin_or_gmod;

	# figure out what to print
	if ($use_guardian)            { $guardian_checked           = ' checked="checked" ' }
	if ($use_htaccess)            { $htaccess_checked           = ' checked="checked" ' }
	if ($disallow_proxy_on)       { $proxy_on_checked           = ' checked="checked" ' }
	if ($disallow_proxy_notify)   { $proxy_notify_checked       = ' checked="checked" ' }
	if ($disallow_proxy_htaccess) { $proxy_htaccess_checked     = ' checked="checked" ' }
	if ($referer_on)              { $referer_on_checked         = ' checked="checked" ' }
	if ($referer_notify)          { $referer_notify_checked     = ' checked="checked" ' }
	if ($referer_htaccess)        { $referer_htaccess_checked   = ' checked="checked" ' }
	if ($harvester_on)            { $harvester_on_checked       = ' checked="checked" ' }
	if ($harvester_notify)        { $harvester_notify_checked   = ' checked="checked" ' }
	if ($harvester_htaccess)      { $harvester_htaccess_checked = ' checked="checked" ' }
	if ($request_on)              { $request_on_checked         = ' checked="checked" ' }
	if ($request_notify)          { $request_notify_checked     = ' checked="checked" ' }
	if ($request_htaccess)        { $request_htaccess_checked   = ' checked="checked" ' }
	if ($string_on)               { $string_on_checked          = ' checked="checked" ' }
	if ($string_notify)           { $string_notify_checked      = ' checked="checked" ' }
	if ($string_htaccess)         { $string_htaccess_checked    = ' checked="checked" ' }
	if ($union_on)                { $union_on_checked           = ' checked="checked" ' }
	if ($union_notify)            { $union_notify_checked       = ' checked="checked" ' }
	if ($union_htaccess)          { $union_htaccess_checked     = ' checked="checked" ' }
	if ($clike_on)                { $clike_on_checked           = ' checked="checked" ' }
	if ($clike_notify)            { $clike_notify_checked       = ' checked="checked" ' }
	if ($clike_htaccess)          { $clike_htaccess_checked     = ' checked="checked" ' }
	if ($script_on)               { $script_on_checked          = ' checked="checked" ' }
	if ($script_notify)           { $script_notify_checked      = ' checked="checked" ' }
	if ($script_htaccess)         { $script_htaccess_checked    = ' checked="checked" ' }

	## make splits turn into linefeeds for the forms
	chomp $banned_harvesters;
	chomp $banned_referers;
	chomp $banned_requests;
	chomp $banned_strings;
	chomp $whitelist;
	$banned_harvesters =~ s~\|~\n~g;
	$banned_referers   =~ s~\|~\n~g;
	$banned_requests   =~ s~\|~\n~g;
	$banned_strings    =~ s~\|~\n~g;
	$whitelist         =~ s~\|~\n~g;
	@access_denied = &update_htaccess("load");

	foreach (@access_denied) {
		chomp $_;
		$acc_denied .= "$_\n";
	}

	$yymain .= qq~
<form action="$adminurl?action=setup_guardian2" method="post" enctype="application/x-www-form-urlencoded">
 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian.gif" alt="" border="0" /> <b>$guardian_txt{'title'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		  $guardian_txt{'description'}<br /><br />
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'general'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'use_guardian'}
			<input type="checkbox" name="use_guardian" value="1"$guardian_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'use_htaccess'}
			<input type="checkbox" name="use_htaccess" value="1"$htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_list'}
		 </div>
		 <div class="setting_cell4">
			<textarea cols="40" rows="8" name="access_denied" style="width:98%">$acc_denied</textarea>
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'proxy'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'proxy_on'}
			<input type="checkbox" name="disallow_proxy_on" value="1"$proxy_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'white_list'}
		 </div>
		 <div class="setting_cell4">
			<textarea cols="40" rows="8" name="whitelist" style="width:98%">$whitelist</textarea>
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="disallow_proxy_notify" value="1"$proxy_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="disallow_proxy_htaccess" value="1"$proxy_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'referer'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'referer_on'}
			<input type="checkbox" name="referer_on" value="1"$referer_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'referer_list'}
		 </div>
		 <div class="setting_cell4">
			<textarea cols="40" rows="8" name="banned_referers" style="width:98%">$banned_referers</textarea>
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="referer_notify" value="1"$referer_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="referer_htaccess" value="1"$referer_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'harvester'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'harvester_on'}
			<input type="checkbox" name="harvester_on" value="1"$harvester_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'harvester_list'}
		 </div>
		 <div class="setting_cell4">
			<textarea cols="40" rows="8" name="banned_harvesters" style="width:98%">$banned_harvesters</textarea>
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="harvester_notify" value="1"$harvester_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="harvester_htaccess" value="1"$harvester_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'request'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'request_on'}
			<input type="checkbox" name="request_on" value="1"$request_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'request_list'}
		 </div>
		 <div class="setting_cell4">
			<textarea cols="40" rows="8" name="banned_requests" style="width:98%">$banned_requests</textarea>
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="request_notify" value="1"$request_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="request_htaccess" value="1"$request_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'string'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'string_on'}
			<input type="checkbox" name="string_on" value="1"$string_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'string_list'}
		 </div>
		 <div class="setting_cell4">
			<textarea cols="40" rows="8" name="banned_strings" style="width:98%">$banned_strings</textarea>
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="string_notify" value="1"$string_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="string_htaccess" value="1"$string_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'script'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'script_on'}
			<input type="checkbox" name="script_on" value="1"$script_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="script_notify" value="1"$script_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="script_htaccess" value="1"$script_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'union'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'union_on'}
			<input type="checkbox" name="union_on" value="1"$union_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="union_notify" value="1"$union_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="union_htaccess" value="1"$union_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>

<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="left" class="titlebg">
		 <img src="$imagesdir/guardian_icon.gif" alt="" border="0" /> <b>$guardian_txt{'clike'}</b>
	   </td>
     </tr>
     <tr valign="middle">
       <td align="left" class="windowbg2"><br />
		 <div class="setting_cell3">
			$guardian_txt{'clike_on'}
			<input type="checkbox" name="clike_on" value="1"$clike_on_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'notify'}
			<input type="checkbox" name="clike_notify" value="1"$clike_notify_checked />
		 </div>
	   <br />
		 <div class="setting_cell3">
			$guardian_txt{'htaccess_add'}
			<input type="checkbox" name="clike_htaccess" value="1"$clike_htaccess_checked /><br />$guardian_txt{'htaccess_support'}
		 </div>
	   </td>
     </tr>
   </table>
 </div>


<br />

 <div class="bordercolor" style="padding: 0px; width: 99%; margin-left: 0px; margin-right: auto;">
   <table width="100%" cellspacing="1" cellpadding="4">
     <tr valign="middle">
       <td align="center" class="catbg">
		 <input type="submit" value="$guardian_txt{'save'}" class="button" />
	   </td>
     </tr>
   </table>
 </div>
</form>
~;
	$yytitle     = $guardian_txt{'setup'};
	$action_area = "setup_guardian";
	&AdminTemplate;
}

sub setup_guardian2 {
	&is_admin_or_gmod;
	my @onoff = qw/
	  use_guardian use_htaccess disallow_proxy_on disallow_proxy_htaccess referer_on referer_htaccess harvester_on harvester_htaccess request_on request_htaccess string_on string_htaccess union_on union_htaccess clike_on clike_htaccess script_on script_htaccess disallow_proxy_notify referer_notify harvester_notify request_notify string_notify union_notify clike_notify script_notify/;

	# Set as 0 or 1 if box was checked or not
	my $fi;
	map { $fi = lc $_; ${$_} = $FORM{$fi} == 1 ? 1 : 0; } @onoff;

	$banned_harvesters = $FORM{'banned_harvesters'};
	$banned_referers   = $FORM{'banned_referers'};
	$banned_requests   = $FORM{'banned_requests'};
	$banned_strings    = $FORM{'banned_strings'};
	$access_denied     = $FORM{'access_denied'};
	$whitelist         = $FORM{'whitelist'};
	chomp $banned_harvesters;
	chomp $banned_referers;
	chomp $banned_requests;
	chomp $banned_strings;
	chomp $whitelist;
	$banned_harvesters =~ s~\r~~g;
	$banned_referers   =~ s~\r~~g;
	$banned_requests   =~ s~\r~~g;
	$banned_strings    =~ s~\r~~g;
	$access_denied     =~ s~\r~~g;
	$whitelist         =~ s~\r~~g;
	$banned_harvesters =~ s~\n~|~g;
	$banned_referers   =~ s~\n~|~g;
	$banned_requests   =~ s~\n~|~g;
	$banned_strings    =~ s~\n~|~g;
	$access_denied     =~ s~\n~,~g;
	$whitelist         =~ s~\n~|~g;

	# We shouldn't let them block POST and GET since it'll mess things up.
	$banned_requests   =~ s~post~~ig;
	$banned_requests   =~ s~get~~ig;
	$banned_requests   =~ s~\|+~\|~ig; # Clean up extra pipes

	require "$admindir/NewSettings.pl";
	&SaveSettingsTo('Settings.pl');

	@access_denied = split(/\,/, $access_denied);
	&update_htaccess("save", @access_denied);

	$yySetLocation = qq~$adminurl~;
	&redirectexit;
}

sub update_htaccess {
	my ($action, @values) = @_;
	my ($htheader, $htfooter, @denies, @htout);
	if (!$action) { return 0; }
	fopen(HTA, ".htaccess");
	@htlines = <HTA>;
	fclose(HTA);

	# header to determine only who has access to the main script, not the admin script
	$htheader = qq~<Files YaBB*>~;
	$htfooter = qq~</Files>~;
	$start = 0;
	foreach (@htlines) {
		chomp $_;
		if ($_ eq $htheader){$start = 1;}
		if ($start == 0 && !($_ =~ m/\#/) && $_ ne ""){push(@htout, "$_\n");}
		if ($_ eq $htfooter){$start = 0;}
		if ($_ =~ m/Deny from / && $start == 1) {
			$_ =~ s~Deny from ~~g;
			push(@denies, $_);
		}
	}
	if ($action eq "load") {
		return @denies;
	} elsif ($action eq "save" && $use_htaccess) {
		$mylastdate = &timeformat($date, 1);
		fopen(HTA, ">.htaccess");
		print HTA "# Last modified by The Guardian: $mylastdate GMT #\n\n";
		print HTA @htout;
		if(@values){
			print HTA "$htheader\n";
			foreach (@values) {
				chomp $_;
				if ($_ ne "") { print HTA "Deny from $_\n"; }
			}
			print HTA "$htfooter\n";
		}
		fclose(HTA);
	}
}

1;
