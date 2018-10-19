var client = new XMLHttpRequest();
client.open('GET', '/api.json?limit=30');
client.onreadystatechange = function() {
  document.getElementById("example").innerHTML = client.responseText;
}
client.send();
