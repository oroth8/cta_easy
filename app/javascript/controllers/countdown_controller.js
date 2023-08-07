// app/javascript/controllers/countdown_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["time", "list"];

  connect() {
    this.startCountdown();
  }

  startCountdown() {
    const countdownElements = this.timeTargets;

    const updateCountdown = () => {
      countdownElements.forEach((element) => {
        console.log({element})
        const arrivalTime = new Date(element.dataset.arrivalTime);
        const currentTime = new Date();

        const timeDifference = arrivalTime - currentTime;

        if (timeDifference <= 0) {
          element.textContent = "Arrived!";
        } else {
          const seconds = Math.floor((timeDifference / 1000) % 60);
          const minutes = Math.floor((timeDifference / 1000 / 60) % 60);
          const hours = Math.floor(timeDifference / 1000 / 60 / 60);

          element.textContent = `${hours}h ${minutes}m ${seconds}s`;
        }
      });
    };

    setInterval(updateCountdown, 1000);
  }
}
