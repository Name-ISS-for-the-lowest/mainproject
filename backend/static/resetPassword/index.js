console.log("I am here");

//get token from url
const urlParams = new URLSearchParams(window.location.search);
const token = urlParams.get("token");

const resetPasswordButton = document.getElementById("resetPasswordButton");
const form = document.getElementById("passwordResetForm");

resetPasswordButton.addEventListener("click", (e) => {
  console.log("I am clicked");
  //view form data
  const formData = new FormData(form);
  const password = formData.get("password");
  const confirmPassword = formData.get("confirmPassword");
  //run regext on password
  const passRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
  if (!passRegex.test(password)) {
    alert(
      "Password must be at least 8 characters long and contain at least one letter and one number"
    );
    return;
  }
  //check that password and confirm password are the same
  if (password !== confirmPassword) {
    alert("Passwords do not match");
    return;
  } else {
    //send a patch request to the server with the token and password as params
    fetch(
      `http://localhost:8000/resetPassword/?token=${token}&password=${password}`,
      {
        method: "PATCH",
      }
    )
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        alert(data.message);
      });
  }
});
