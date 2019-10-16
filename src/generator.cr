require "./utils"

module Croperty::Generator(T)
  private macro initializer_helper(name, type, init_val, lazy_init, mode)
    {% if lazy_init %}
      @{{ name }} = uninitialized Union({{ type }}, Nil)
    {% else %}
      {% if mode == 0 %}
        @{{ name }} = uninitialized {{ type }}
      {% else %}
        @{{ name }} = uninitialized Union({{ type }}, Nil)
      {% end %}

      {% if init_val %}
        @{{ name }} = {{ init_val }}
      {% end %}
    {% end %}
  end

  private macro getter_helper(name, type, init_val, lazy_init, mode)
    {% if mode == 1 || mode == 2 %}
      def {{ name }}? : Union({{ type }}, Nil)
        @{{ name }}
      end
    {% end %}

    {% if mode == 2 %}
      def {{ name }} : {{ type }}
        @{{ name }}.not_nil!
      end
    {% elsif mode == 0 %}
      {% if lazy_init %}
        def {{ name }} : {{ type }}
          if (value = @{{ name }}).nil?
            @{{ name }} = {{ init_val }}
          else
            value
          end
        end
      {% else %}
        def {{ name }} : {{ type }}
          @{{ name }}
        end
      {% end %}
    {% end %}
  end

  private macro setter_helper(name, type)
    def {{ name }}=(@{{ name }} : {{ type }})
    end
  end

  private macro property_helper(name, type, init_val, lazy_init, mode)
    getter_helper({{ name }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})
    setter_helper({{ name }}, {{ type }})
  end

  private macro getter_gen(target)
    {% for prop in target.resolve.annotations(Croperty::Getter) %}
      {%
        x = prop.named_args
        name = x.keys[0]
        type = x.values[0]
        mode = Croperty::Mode::Default

        if name.id.ends_with?('?')
          name = name.id[0...-1]
          mode = Croperty::Mode::Query
        elsif name.id.ends_with?('!')
          name = name.id[0...-1]
          mode = Croperty::Mode::Exclaim
        end

        init_val = x[:init]
        lazy_init = (init_val && mode == 0) ? x[:lazy_init] : nil
      %}

      initializer_helper({{ name }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})
      getter_helper({{ name }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})
    {% end %}
  end

  private macro property_gen(target)
    {% for prop in target.resolve.annotations(Croperty::Property) %}
      {%
        x = prop.named_args
        name = x.keys[0]
        type = x.values[0]
        mode = Croperty::Mode::Default

        if name.id.ends_with?('?')
          name = name.id[0...-1]
          mode = Croperty::Mode::Query
        elsif name.id.ends_with?('!')
          name = name.id[0...-1]
          mode = Croperty::Mode::Exclaim
        end

        init_val = x[:init]
        lazy_init = (init_val && mode == 0) ? x[:lazy_init] : nil
      %}

      initializer_helper({{ name }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})
      property_helper({{ name }}, {{ type }}, {{ init_val }}, {{ lazy_init }}, {{ mode }})
    {% end %}
  end

  private macro setter_gen(target)
    {% for prop in target.resolve.annotations(Croperty::Setter) %}
      {%
        x = prop.named_args
        name = x.keys[0]
        type = x.values[0]
        init_val = x[:init]
      %}

      initializer_helper({{ name }}, {{ type }}, {{ init_val }}, false, 0)
      setter_helper({{ name }}, {{ type }})
    {% end %}
  end

  private macro multi_property_gen(target)
    {% for multi_prop in target.resolve.annotations(Croperty::MultiProperty) %}
      {% for name, type in multi_prop.named_args %}
        {%
          mode = Croperty::Mode::Default

          if name.id.ends_with?('?')
            name = name.id[0...-1]
            mode = Croperty::Mode::Query
          elsif name.id.ends_with?('!')
            name = name.id[0...-1]
            mode = Croperty::Mode::Exclaim
          end
        %}

        initializer_helper({{ name }}, {{ type }}, nil, false, {{ mode }})
        property_helper({{ name }}, {{ type }}, nil, false, {{ mode }})
      {% end %}
    {% end %}
  end

  private macro multi_getter_gen(target)
    {% for multi_get in target.resolve.annotations(Croperty::MultiGetter) %}
      {% for name, type in multi_get.named_args %}
        {%
          mode = Croperty::Mode::Default

          if name.id.ends_with?('?')
            name = name.id[0...-1]
            mode = Croperty::Mode::Query
          elsif name.id.ends_with?('!')
            name = name.id[0...-1]
            mode = Croperty::Mode::Exclaim
          end
        %}

        initializer_helper({{ name }}, {{ type }}, nil, false, {{ mode }})
        getter_helper({{ name }}, {{ type }}, nil, false, {{ mode }})
      {% end %}
    {% end %}
  end

  private macro multi_setter_gen(target)
    {% for multi_set in target.resolve.annotations(Croperty::MultiSetter) %}
      {% for name, type in multi_set.named_args %}
        initializer_helper({{ name }}, {{ type }}, nil, false, 0)
        setter_helper({{ name }}, {{ type }})
      {% end %}
    {% end %}
  end

  macro included
    property_gen({{ T }})
    setter_gen({{ T }})
    getter_gen({{ T }})

    multi_property_gen({{ T }})
    multi_getter_gen({{ T }})
    multi_setter_gen({{ T }})
  end
end
