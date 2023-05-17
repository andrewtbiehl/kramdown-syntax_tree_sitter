~~~html
<!DOCTYPE html>
<html>
   <body>
      <button onclick="updateButtonInfo()">Click me</button>
      <p id="button-info">Not yet clicked.</p>
      <script>
         function updateButtonInfo() {
           document.getElementById("button-info").innerHTML = "Clicked!";
         }
      </script>
   </body>
</html>
~~~
