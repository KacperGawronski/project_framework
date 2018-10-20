var client = new XMLHttpRequest();
var contentARR;
var contentTEXT;


function parse_obj(Obj){
	txt="<tr>"
	for(k in Obj){
		"<td>"+Obj[k]+"</td>"
	}
	return txt+"</tr>"
}


client.open('GET', '/api.json?limit=300');
client.onreadystatechange = function() {
  contentTEXT = "<table>"+JSON.parse(client.responseText).forEach(parse_obj)+"</table>";
}
client.send();

document.getElementById("example").innerHTML = contentTEXT
