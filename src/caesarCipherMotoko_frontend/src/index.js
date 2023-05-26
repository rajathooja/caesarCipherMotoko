import { caesarCipherMotoko_backend } from "../../declarations/caesarCipherMotoko_backend";

// declare the decode button element
const decodeButton = document.getElementById('decode');

// encode button action
document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");

  // capture the form data
  const message = document.getElementById("message").value.toString();
  const offset = parseInt(document.getElementById("offset").value);

  button.setAttribute("disabled", true);

  // Interact with caesarCipher actor, setting the offset and calling the encode method
  await caesarCipherMotoko_backend.setOffset(offset);
  const processedOutput = await caesarCipherMotoko_backend.encodeInput(message);

  button.removeAttribute("disabled");

  // display the encoded message
  document.getElementById("processedOutput").innerText = processedOutput;

  return false;
});

// decode button action
decodeButton.addEventListener('click', async (e) => {
  e.preventDefault();

  // capture the form data
  const message = document.getElementById("message").value.toString();
  const offset = parseInt(document.getElementById("offset").value);

  decodeButton.setAttribute("disabled", true);

  // Interact with caesarCipher actor, setting the offset and calling the decode method
  await caesarCipherMotoko_backend.setOffset(offset);
  const processedOutput = await caesarCipherMotoko_backend.decodeInput(message);

  decodeButton.removeAttribute("disabled");

  // display the encoded message
  document.getElementById("processedOutput").innerText = processedOutput;

  return false;
});
