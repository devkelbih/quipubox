/// Vista resumida de una [Variedad] usada cuando se carga
/// la relación 1:N desde el lado de [Fruta].
///
/// ¿Por qué existe?
/// ----------------
/// `Fruta` y `Variedad` tienen una relación bidireccional en el
/// dominio: una fruta tiene muchas variedades, y cada variedad
/// conoce a su fruta padre (vía `idFruta` / `fruta`).
///
/// Si `Fruta.variedades` guardara `List<Variedad>`, se produciría
/// un grafo cíclico en memoria:
///
///     Fruta(16) → Variedad(5) → Fruta(16) → Variedad(5) → ...
///
/// Esto rompe `toString()`, la igualdad profunda, la serialización
/// y cualquier recorrido recursivo.
///
/// Adicionalmente, el card de frutas solo necesita mostrar el
/// nombre y estado de cada variedad, no la entidad completa.
///
/// Por eso este resumen:
///  - Rompe el ciclo (no referencia a [Fruta]).
///  - Expone solo lo necesario para UI.
///  - Evita acoplar el feature `frutas` al feature `variedades`
///    más allá de lo mínimo.
///
/// Si en el futuro el card de frutas necesita más campos de la
/// variedad, se agregan aquí — pero NO se reemplaza por la
/// entidad `Variedad` completa.
class VariedadResumen {
  final int id;
  final String nombre;
  final bool estado;

  const VariedadResumen({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  VariedadResumen copyWith({int? id, String? nombre, bool? estado}) {
    return VariedadResumen(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
    );
  }
}
