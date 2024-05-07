{
  description = "A collection of avas flake templates";

  outputs = { self }: {

    templates = {

      ava_simple = {
        path = ./ava_simple;
        description = "A very basic ava flake";
      };

    };

    defaultTemplate = self.templates.ava_simple;

  };
}
