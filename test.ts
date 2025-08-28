// Test file for LSP validation
interface User {
  id: number;
  name: string;
  email?: string;
}

function createUser(data: User): User {
  return {
    ...data,
  };
}

const user: User = createUser({
  id: 1,
  name: "Test User",
});

console.log(user.name);
