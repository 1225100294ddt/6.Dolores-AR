import 'package:flutter/material.dart';

import '../dominio/negocio.dart';
import 'negocios_viewmodel.dart';

class PantallaNegocios extends StatefulWidget {
  final NegociosViewModel vm;

  const PantallaNegocios({super.key, required this.vm});

  @override
  State<PantallaNegocios> createState() => _PantallaNegociosState();
}

class _PantallaNegociosState extends State<PantallaNegocios> {
  final _busqueda = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.vm.cargar();
  }

  @override
  void dispose() {
    _busqueda.dispose();
    widget.vm.dispose();
    super.dispose();
  }

  Future<void> _nuevo() async {
    final nombre = TextEditingController();
    final categoria = TextEditingController();
    final telefono = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo negocio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextField(
                controller: telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (ok == true) {
      if (nombre.text.trim().isEmpty || categoria.text.trim().isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nombre y categoría son obligatorios.')),
        );
      } else {
        await widget.vm.agregar(Negocio(
          nombre: nombre.text.trim(),
          categoria: categoria.text.trim(),
          telefono: telefono.text.trim(),
        ));
      }
    }
    nombre.dispose();
    categoria.dispose();
    telefono.dispose();
  }

  Widget _contenido() {
    final vm = widget.vm;
    switch (vm.estado) {
      case Estado.inicial:
      case Estado.cargando:
        return const Center(child: CircularProgressIndicator());
      case Estado.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 64),
                const SizedBox(height: 12),
                Text(vm.mensajeError ?? 'Ocurrió un error.',
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => vm.cargar(busqueda: _busqueda.text),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      case Estado.vacio:
        return const Center(
            child: Text('Aún no hay negocios. ¡Agrega el primero!'));
      case Estado.listo:
        return RefreshIndicator(
          onRefresh: () => vm.cargar(busqueda: _busqueda.text),
          child: ListView(
            children: [
              for (final Negocio n in vm.negocios)
                Dismissible(
                  key: ValueKey(n.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => vm.eliminar(n),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.store)),
                    title: Text(n.nombre),
                    subtitle: Text('${n.categoria} · ${n.telefono}'),
                    trailing: IconButton(
                      tooltip: 'Marcar favorito',
                      icon: Icon(
                        n.favorito ? Icons.star : Icons.star_border,
                        color: n.favorito ? Colors.amber : null,
                      ),
                      onPressed: () => vm.alternarFavorito(n),
                    ),
                  ),
                ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.vm,
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: const Text('Directorio · Dolores Hidalgo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _nuevo,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _busqueda,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Buscar negocio',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _busqueda.clear();
                      widget.vm.cargar();
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (valor) => widget.vm.cargar(busqueda: valor),
              ),
            ),
            Expanded(child: _contenido()),
          ],
        ),
      ),
    );
  }
}
