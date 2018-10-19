var client = new XMLHttpRequest();
client.open('GET', '/api.json?limits=30');
client.onreadystatechange = function() {
  alert(client.responseText);
  document.getElementById("example").innerHTML = client.responseText;
}
client.send();
