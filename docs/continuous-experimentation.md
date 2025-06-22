# Continuous Experimentation

## 🎯 Goal of the Experiment

We introduced a new feature — a **dark mode toggle** — in the `v2` version of our web app. This experiment aims to assess whether users interact with the toggle, which would indicate interest in personalized UI features.

---

## ⚙️ What Changed Compared to the Base Design

- A toggle switch was added to the UI in `v2` for enabling dark mode.
- Toggling this feature sends a request to `/api/metrics/toggle`, which increments a Prometheus counter (`dark_mode_toggle_total`) labeled by version.
- The base version `v1` does not contain the toggle.
- Sticky session routing via Istio ensures that users consistently interact with either `v1` or `v2`.

---

## 🧪 Hypothesis

> *If users value UI personalization, they will actively interact with the Dark Mode toggle, leading to noticeable toggle activity per session.*

- **Null hypothesis (H₀):** The average number of Dark Mode toggles per session on V2 is less than **0.2**.
- **Alternative hypothesis (H₁):** The average number of Dark Mode toggles per session on V2 is **0.2 or higher**, indicating meaningful user interest.

We approximate this interaction rate using the following metric ratio:

dark_mode_toggle_total / visitor_count_total

This metric captures **toggle intensity per session**, meaning that multiple toggles by the same user will increase the ratio. While it does not measure unique users toggling at least once, a sustained ratio above `0.2` suggests that users find and interact with the feature.
---

## 📏 Metrics

We track the following Prometheus metric:
```text
dark_mode_toggle_total{version="v2"}
Visitor_count_total{version="v2"}

```

This metric records how often users toggle the dark mode.

📉 Grafana Dashboard
We created a Grafana dashboard that displays:

Total toggle usage per session

![Grafana Toggle Rate Visualization](./docs/GrafanaScreenshot.png)




Decision Process
We will observe toggle interaction in v2 over a usage window.

If interaction count shows meaningful use compared to v1 (which has none), we consider promoting the feature to default or expanding it.

If usage is negligible, the feature will be re-evaluated or discarded.

This approach allows us to introduce, observe, and validate UI features through controlled experimentation and data-driven decisions.



