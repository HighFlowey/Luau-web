const numberIndicators = document.querySelectorAll(".number-indicator")
const numberInputs = document.querySelectorAll("button.number-input")

async function number_action(action) {
  const _response = await fetch("http://localhost:3030/number", {
    headers: { action: action || "get" },
    method: "GET",
  });

  return _response.text();
}

for (const [_, element] of numberIndicators.entries()) {
    number_action('get').then((response) => {
        element.innerHTML = "Number: " + response;
    })
}

for (const [_, element] of numberInputs.entries()) {
    element.onclick = async function() {
        const response = await number_action('increase')

        for (const [_, element] of numberIndicators.entries()) {
            element.innerHTML = "Number: " + response
        }
    }
}
