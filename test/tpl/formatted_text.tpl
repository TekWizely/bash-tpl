% myint=100
% mydec=3.14159
% mystr='one\ttwo'

<%$myint%>
<%||$myint%>
<%|%|$myint%>
<%|%d|$myint%>
<%|d|$myint%>
<%|5d|$myint%>
<%|05d|$myint%>
<%|x|$myint%>

<%$mydec%>
<%||$mydec%>
<%|%|$mydec%>
<%|%f|$mydec%>
<%|f|$mydec%>
<%|.2f|$mydec%>
<%|07.2f|$mydec%>

<%$mystr%>
<%||$mystr%>
<%|%|$mystr%>
<%|%s|$mystr%>
<%|s|$mystr%>
<%|20s|$mystr%>.
<%|-20s|$mystr%>.
<%|b|$mystr%>

.<%|b|" $mystr "%>.
<%|b|% echo $mystr%>

.DELIMS tag="{{ }}" tag-fmt="[ ]"

{{$myint}}
{{[]$myint}}
{{[%]$myint}}
{{[%d]$myint}}
{{[d]$myint}}
{{[5d]$myint}}
{{[05d]$myint}}
{{[x]$myint}}

{{$mydec}}
{{[]$mydec}}
{{[%]$mydec}}
{{[%f]$mydec}}
{{[f]$mydec}}
{{[.2f]$mydec}}
{{[07.2f]$mydec}}

{{$mystr}}
{{[]$mystr}}
{{[%]$mystr}}
{{[%s]$mystr}}
{{[s]$mystr}}
{{[20s]$mystr}}.
{{[-20s]$mystr}}.
{{[b]$mystr}}

.{{[b]" $mystr "}}.
{{[b]% echo $mystr}}
