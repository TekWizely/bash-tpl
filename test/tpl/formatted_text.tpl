% myint=100
% myintfmt='%d'
% mydec=3.14159
% mydecfmt='%f'
% mystr='one\ttwo'

<%$myint%>
<%||$myint%>
<% | %d | $myint%>
<%|%d|$myint%>
<%|${myintfmt}|$myint%>
<%|%5d|$myint%>
<%|%05d|$myint%>
<%|%x|$myint%>

<%$mydec%>
<%||$mydec%>
<% | %f | $mydec%>
<%|%f|$mydec%>
<%|${mydecfmt}|$mydec%>
<%|%.2f|$mydec%>
<%|%07.2f|$mydec%>

<%$mystr%>
<%||$mystr%>
<% | %s | $mystr%>
<%|%s|$mystr%>
<%|%20s|$mystr%>.
<%|%-20s|$mystr%>.
<%|%b|$mystr%>

.<% | %b | " $mystr " %>.
<%|%b|% echo $mystr%>

.DELIMS tag="{{ }}" tag-fmt="[ ]"

{{$myint}}
{{[]$myint}}
{{ [ %d ] $myint}}
{{[%d]$myint}}
{{[${myintfmt}]$myint}}
{{[%5d]$myint}}
{{[%05d]$myint}}
{{[%x]$myint}}

{{$mydec}}
{{[]$mydec}}
{{ [ %f ] $mydec}}
{{[%f]$mydec}}
{{[${mydecfmt}]$mydec}}
{{[%.2f]$mydec}}
{{[%07.2f]$mydec}}

{{$mystr}}
{{[]$mystr}}
{{ [ %s ] $mystr}}
{{[%s]$mystr}}
{{[%20s]$mystr}}.
{{[%-20s]$mystr}}.
{{[%b]$mystr}}

.{{ [ %b ] " $mystr " }}.
{{[%b]% echo $mystr}}
