<template>
  <div class="container">
    <h1>Nuke</h1>
    <p>Welcome to your Nuke desktop application.</p>
    <div class="status">
      Backend: <span class="online">Connected</span>
    </div>
  </div>
</template>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  font-family: sans-serif;
  background-color: #1a1a1a;
  color: #ffffff;
}
h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
}
.status {
  margin-top: 2rem;
}
.online {
  color: #4caf50;
  font-weight: bold;
}
</style>
