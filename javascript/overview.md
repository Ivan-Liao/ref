1. Variable declaration
   1. const / var (function scoped)
   2. let (block scoped)
      1. Use for loop or temp var
2. ternary operator 
   1. 
```
// shorthand if else statement
const name = base64name ? Buffer.from(base64name, 'base64').toString(): 'World';


// equivalent code
let name;

if (base64name) {
    // Decode the base64 string
    name = Buffer.from(base64name, 'base64').toString();
} else {
    // Use a default value
    name = 'World';
}

// Pub/Sub treats the message body as a blob of bytes. It doesn't know if you are sending a JSON object, a plain string, or a small image. Encoding it in Base64 ensures that special characters (like newlines or symbols) don't break the HTTP request that triggers your Function.
```
   2. 

