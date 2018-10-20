var client = new XMLHttpRequest();
var contentTEXT="";


function parse_obj(Obj){
	document.getElementById("example").innerHTML +="<tr>"
	for(k in Obj){
		document.getElementById("example").innerHTML +="<td>"+Obj[k]+"</td>"
	}
	document.getElementById("example").innerHTML +="</tr>"
}

client.open('GET', '/api.json?limit=30');
client.onreadystatechange = function() {
  document.getElementById("example").innerHTML += "<table>"
  (JSON.parse(client.responseText)).forEach(parse_obj)
  document.getElementById("example").innerHTML +="</table>";
}
client.send();



 gen_value
