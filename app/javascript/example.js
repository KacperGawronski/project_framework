
var client = new XMLHttpRequest();
var contentTEXT = "<table>"
function parse_obj(Obj){
	contentTEXT +="<tr>"
	for(k in Obj){
		contentTEXT +="<td>"+Obj[k]+"</td>"
	}
	contentTEXT +="</tr>"
}

client.open('GET', '/api.json?limit=30');
client.onreadystatechange = function() {
  (JSON.parse(client.responseText)).forEach(parse_obj)
  contentTEXT +="</table>";
}
client.send();
document.getElementById("example").innerHTML = contentTEXT;
