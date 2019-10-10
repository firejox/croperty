require "./utils"

module Croperty::Generator(T)
  private macro getter_helper(id, type, init_val, lazy_init, mode)
    {% if lazy_init %}
      @{{ id }} : Union({{ type }}, Nil)
    {% else %}
      {% if mode == 0 %}
        @{{ id }} = uninitialized {{ type }}
      {% else %}
        @{{ id }} : Union({{ type }}, Nil)
      {% end %}

      {% if init_val %}
        @{{ id }} = {{ init_val }}
      {% end %}
    {% end %}

    {% if mode == 1 || mode == 2 %}
      def {{ id }}? : Union({{ type }}, Nil)
        @{{ id }}
      end
    {% end %}

    {% if mode == 2 %}
      def {{ id }} : {{ type }}
        @{{ id }}.not_nil!
      end
    {% elsif mode == 0 %}
      {% if lazy_init %}
        def {{ id }} : {{ type }}
          if (value = @{{ id }}).nil?
            @{{ id }} = {{ init_val }}
          else
            value
          end
        end
      {% else %}
        def {{ id }} : {{ type }}
          @{{ id }}
        end
      {% end %}
    {% end %}
  end

  private macro property_helper(id, type, init_val, lazy_init, mode)
    getter_helper({{ id }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})

    def {{ id }}=(@{{ id }} : {{ type }})
    end
  end

  private macro getter_gen(target)
    {% for prop in target.resolve.annotations(Croperty::Getter) %}
      {%
        x = prop.named_args
        id = x.keys[0]
        type = x.values[0]
        mode = x[:mode] ? x[:mode].resolve : Croperty::Mode::Default
        init_val = x[:init]
        lazy_init = (init_val && mode == 0) ? x[:lazy_init] : nil
      %}

      getter_helper({{ id }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})
    {% end %}
  end

  private macro property_gen(target)
    {% for prop in target.resolve.annotations(Croperty::Property) %}
      {%
        x = prop.named_args
        id = x.keys[0]
        type = x.values[0]
        mode = x[:mode] ? x[:mode].resolve : Croperty::Mode::Default
        init_val = x[:init]
        lazy_init = (init_val && mode == 0) ? x[:lazy_init] : nil
      %}

      property_helper({{ id }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})
    {% end %}
  end

  private macro setter_gen(target)
    {% for prop in target.resolve.annotations(Croperty::Setter) %}
      {%
        x = prop.named_args
        id = x.keys[0]
        type = x.values[0]
        init_val = x[:init]
      %}

      @{{ id }} = uninitialized {{ type }}

      {% if init_val %}
        @{{ id }} = {{ init_val }}
      {% end %}

      def {{ id }}=(@{{ id }} : {{ type }})
      end
    {% end %}
  end

  macro included
    property_gen({{ T }})
    setter_gen({{ T }})
    getter_gen({{ T }})
  end
end
