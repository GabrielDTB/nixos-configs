{...}: {
  programs.claude-sandboxed = {
    sharedLimit = {
      memoryGB = 8;
    };
  };
}
