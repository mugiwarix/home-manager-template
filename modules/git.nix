{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";

      # Uncomment and replace these examples with your Git identity.
      # user.name = "Your Name";
      # user.email = "you@example.com";
    };
  };
}
