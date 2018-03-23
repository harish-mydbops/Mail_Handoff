day=`date +"(%d-%B-%Y)"`
Time=`date +"%H"`
complete_tasks=`cat handoff | awk '/Completed/,/Ongoing/' | awk '/Completed/,/Pending/' | awk '/Completed/,/Schedule/' | awk '/Completed/,/Issues/' | sed '$d' | awk NF | tail -n+3 | wc -l`
ongoing_tasks=`cat handoff | awk '/Ongoing/,/Pending/' | awk '/Ongoing/,/Schedule/' | awk '/Ongoing/,/Issues/' | sed '$d' | awk NF | tail -n+3 | wc -l`
pending_tasks=`cat handoff | awk '/Pending/,/Schedule/' | awk '/Pending/,/Issues/' | sed '$d' | awk NF | tail -n+3 | wc -l`
schedule_tasks=`cat handoff | awk '/Schedule/,/Issues/' | sed '$d' | awk NF | tail -n+3 | wc -l`
issues=`cat handoff | awk '/Issues/,0' | awk NF | tail -n+3 | wc -l`
user=`whoami`
sender=`echo ${user^}`

if [[ $Time -gt 00 && $Time -le 9 ]]; then
	Shift='Morning'
elif [[ $Time -gt 9 && $Time -le 18 ]]; then
	Shift='Afternoon'
elif [[ $Time -gt 18 ]]; then
	Shift='Night'
fi

echo "<table border='1' width='70%' table-layout='fixed' cellpadding='5' cellspacing='0' height='30'>
<caption>From: $sender</caption>
<TR bgcolor='#ff751a'><TH align='center' colspan='4'>Handoff to $Shift Shift</TH></TR>
<TR bgcolor='#33bbff'><TH width='3%'table-layout='fixed'>S.No</TH><TH width='15%'>Client Name</TH><TH width='37%'>Short Description</TH><TH width='15%'>Comments</TH></TR>" > mail.html

Completed(){
  echo "<TR><TH bgcolor='#ffff66' align='center' colspan='4'>Completed Tasks</TH></TR>" >> mail.html
  for (( i = 1; i <= $complete_tasks ; i++ )); do
  	client=`cat handoff | awk '/Completed/,/Ongoing/' | awk '/Completed/,/Pending/' | awk '/Completed/,/Schedule/' | awk '/Completed/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p | awk -F "::" '{print $1}'`
    description=`cat handoff | awk '/Completed/,/Ongoing/' | awk '/Completed/,/Pending/' | awk '/Completed/,/Schedule/' | awk '/Completed/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $2}'`
    comments=`cat handoff | awk '/Completed/,/Ongoing/' | awk '/Completed/,/Pending/' | awk '/Completed/,/Schedule/' | awk '/Completed/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $3}'`
  	if [[ -z $comments ]]; then
  		echo "<TR bgcolor='#ccffcc'><TD align='center'>$i</TD><TD align='center'>$client</TD><TD align='center'>$description</TD><TD align='center'>Completed</TD></TR>" >> mail.html
  	else
  		echo "<TR bgcolor='#ccffcc'><TD align='center'>$i</TD><TD align='center'>$client</TD><TD align='center'>$description</TD><TD align='center'>$comments</TD></TR>" >> mail.html
  	fi
  done
}

Ongoing(){
  echo "<TR><TH bgcolor='#ffff66' align='center' colspan='4'>Ongoing Tasks Task</TH></TR>" >> mail.html
  for (( i = 1; i <= $ongoing_tasks ; i++ )); do
  	client=`cat handoff | awk '/Ongoing/,/Pending/' | awk '/Ongoing/,/Schedule/' | awk '/Ongoing/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $1}'`
  	description=`cat handoff | awk '/Ongoing/,/Pending/' | awk '/Ongoing/,/Schedule/' | awk '/Ongoing/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $2}'`
		comments=`cat handoff | awk '/Ongoing/,/Pending/' | awk '/Ongoing/,/Schedule/' | awk '/Ongoing/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $3}'`
  	echo "<TR bgcolor='#ccffcc'><TD align='center'>$i</TD><TD align='center'>$client</TD><TD align='center'>$description</TD><TD align='center'>$comments</TD></TR>" >> mail.html
  done
}

Pending(){
  echo "<TR><TH bgcolor='#ffff66' align='center' colspan='4'>Pending Task</TH></TR>" >> mail.html
  for (( i = 1; i <= $pending_tasks ; i++ )); do
  	client=`cat handoff | awk '/Pending/,/Schedule/' | awk '/Pending/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $1}'`
 		description=`cat handoff | awk '/Pending/,/Schedule/' | awk '/Pending/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $2}'`
  	comments=`cat handoff | awk '/Pending/,/Schedule/' | awk '/Pending/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $3}'`
  	echo "<TR bgcolor='#ccffcc'><TD align='center'>$i</TD><TD align='center'>$client</TD><TD align='center'>$description</TD><TD align='center'>$comments</TD></TR>" >> mail.html
  done
}

Schedule(){
  echo "<TR><TH bgcolor='#ffff66' align='center' colspan='4'>Schedule Task</TH></TR>" >> mail.html
  for (( i = 1; i <= $schedule_tasks ; i++ )); do
  	client=`cat handoff | awk '/Schedule/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $1}'`
  	description=`cat handoff | awk '/Schedule/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $2}'`
  	comments=`cat handoff | awk '/Schedule/,/Issues/' | sed '$d' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $3}'`
  	echo "<TR bgcolor='#ccffcc'><TD align='center'>$i</TD><TD align='center'>$client</TD><TD align='center'>$description</TD><TD align='center'>$comments</TD></TR>" >> mail.html
  done
}

Issues(){
  echo "<TR><TH bgcolor='#ffff66' align='center' colspan='4'>Issues</TH></TR>" >> mail.html
  for (( i = 1; i <= $issues ; i++ )); do
  		client=`cat handoff | awk '/Issues/,0' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $1}'`
  		description=`cat handoff | awk '/Issues/,0' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $2}'`
  		comments=`cat handoff | awk '/Issues/,0' | awk NF | tail -n+3 | sed -n "$i"p  | awk -F "::" '{print $3}'`
  		echo "<TR bgcolor='#ccffcc'><TD align='center'>$i</TD><TD align='center'>$client</TD><TD align='center'>$description</TD><TD align='center'>$comments</TD></TR>" >> mail.html
  done
} 

if [[ $complete_tasks -ne 0 ]]; then
	Completed
fi

if [[ $ongoing_tasks -ne 0 ]]; then
	Ongoing
fi

if [[ $pending_tasks -ne 0 ]]; then
	Pending
fi

if [[ $schedule_tasks -ne 0 ]]; then
	Schedule
fi

if [[ $issues -ne 0 ]]; then
	Issues
fi

echo "</table><body><br>with regards,<br>OPS Team<br>Mydbops.</body>" >> mail.html
sed -i "1 i\Subject:Handoff to ${Shift} Shift ${day}\nContent-Type:text/html; charset="us-ascii"" mail.html
sendmail -f dba-group@mydbops.com -t dba-group@mydbops.com < mail.html
