var client = new XMLHttpRequest();
var contentARR;
client.open('GET', '/api.json?');
client.onreadystatechange = function() {
  contentARR = JSON.parse(client.responseText);
}
client.send();

function parse_obj(Obj){
	txt="<tr>"
	for(k in Obj){
		"<td>"+Obj[k]+"</td>"
	}
	return txt+"</tr>"
}


function generate_content(){
	return "<table>"+contentARR.forEach(parse_obj)+"</table>"
}

document.getElementById("example").innerHTML = generate_content()
