import 'package:flutter/material.dart';
import 'package:tomathics_design_system/tomathics_design_system.dart';

enum _LoginPreviewState { normal, incorrectPassword, capsLock, emptyFields }

class LoginDemoPage extends StatefulWidget {
  const LoginDemoPage({
    required this.isDark,
    required this.onThemeChanged,
    required this.onReturn,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onReturn;

  @override
  State<LoginDemoPage> createState() => _LoginDemoPageState();
}

class _LoginDemoPageState extends State<LoginDemoPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  _LoginPreviewState _previewState = _LoginPreviewState.normal;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= TomathicsLayout.expandedBreakpoint) {
      return Scaffold(
        body: Row(
          children: [
            const Expanded(flex: 5, child: _LoginBrandPanel()),
            Expanded(flex: 6, child: _loginContent(context, compact: false)),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: const _CompactLoginBrand(),
            ),
            Expanded(child: _loginContent(context, compact: true)),
          ],
        ),
      ),
    );
  }

  Widget _loginContent(BuildContext context, {required bool compact}) {
    final palette = Theme.of(context).colorScheme;
    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton.icon(
                  key: const ValueKey('login-demo-return'),
                  onPressed: widget.onReturn,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Voltar à galeria'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.isDark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      size: 18,
                      color: palette.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Switch(
                      key: const ValueKey('login-demo-theme-switch'),
                      value: widget.isDark,
                      onChanged: widget.onThemeChanged,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'ACESSO AO WORKSPACE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: palette.secondary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Acesse seu workspace',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Entre para continuar organizando suas automações.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: palette.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            TomathicsPanel(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TomathicsTextField(
                    label: 'E-mail',
                    controller: _emailController,
                    hint: 'voce@exemplo.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                    errorText: _previewState == _LoginPreviewState.emptyFields
                        ? 'Informe seu e-mail.'
                        : null,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  TomathicsTextField(
                    label: 'Senha',
                    controller: _passwordController,
                    hint: 'Digite sua senha',
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      key: const ValueKey('login-password-visibility'),
                      tooltip: _obscurePassword
                          ? 'Mostrar senha'
                          : 'Ocultar senha',
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    obscureText: _obscurePassword,
                    errorText: switch (_previewState) {
                      _LoginPreviewState.incorrectPassword =>
                        'Senha incorreta.',
                      _LoginPreviewState.emptyFields => 'Informe sua senha.',
                      _ => null,
                    },
                    helperText: _previewState == _LoginPreviewState.capsLock
                        ? 'Caps Lock está ativado.'
                        : null,
                    required: true,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (value) =>
                                setState(() => _rememberMe = value ?? false),
                          ),
                          const Text('Manter conectado'),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'A recuperação de senha é apenas demonstrativa.',
                                ),
                              ),
                            ),
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ],
                  ),
                  if (_previewState == _LoginPreviewState.incorrectPassword)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TomathicsMessageBanner(
                        title: 'Não foi possível entrar',
                        message:
                            'Confira seu e-mail e sua senha e tente novamente.',
                        tone: TomathicsBannerTone.danger,
                      ),
                    ),
                  if (_previewState == _LoginPreviewState.capsLock)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TomathicsMessageBanner(
                        title: 'Caps Lock ativado',
                        message:
                            'A senha diferencia letras maiúsculas e minúsculas.',
                        tone: TomathicsBannerTone.warning,
                      ),
                    ),
                  SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      key: const ValueKey('login-demo-submit'),
                      onPressed: widget.onReturn,
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Entrar'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Demonstração visual: nenhuma credencial é validada.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TomathicsPanel(
              title: 'Prévia de estados',
              subtitle:
                  'Selecione um exemplo para visualizar o feedback do formulário.',
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _previewChip(
                    key: const ValueKey('login-preview-normal'),
                    label: 'Padrão',
                    state: _LoginPreviewState.normal,
                  ),
                  _previewChip(
                    key: const ValueKey('login-preview-incorrect'),
                    label: 'Senha incorreta',
                    state: _LoginPreviewState.incorrectPassword,
                  ),
                  _previewChip(
                    key: const ValueKey('login-preview-capslock'),
                    label: 'Caps Lock',
                    state: _LoginPreviewState.capsLock,
                  ),
                  _previewChip(
                    key: const ValueKey('login-preview-empty'),
                    label: 'Campos vazios',
                    state: _LoginPreviewState.emptyFields,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (compact) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: content,
      );
    }
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 28),
        child: content,
      ),
    );
  }

  Widget _previewChip({
    required Key key,
    required String label,
    required _LoginPreviewState state,
  }) {
    return ChoiceChip(
      key: key,
      label: Text(label),
      selected: _previewState == state,
      onSelected: (_) => setState(() => _previewState = state),
    );
  }
}

class _CompactLoginBrand extends StatelessWidget {
  const _CompactLoginBrand();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: palette.primary,
            borderRadius: TomathicsRadius.mdAll,
          ),
          child: Icon(
            Icons.account_tree_rounded,
            color: palette.onPrimary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Text('tomathics', style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: palette.primary.withValues(alpha: 0.12),
            borderRadius: TomathicsRadius.pillAll,
          ),
          child: Text(
            'DEMO',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: palette.primary,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginBrandPanel extends StatelessWidget {
  const _LoginBrandPanel();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainerHighest,
        border: Border(right: BorderSide(color: palette.outlineVariant)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -80,
            bottom: -100,
            child: Icon(
              Icons.account_tree_rounded,
              size: 420,
              color: palette.primary.withValues(alpha: 0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: TomathicsRadius.mdAll,
                      ),
                      child: Icon(
                        Icons.account_tree_rounded,
                        color: palette.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'tomathics',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: palette.primary.withValues(alpha: 0.12),
                    borderRadius: TomathicsRadius.pillAll,
                    border: Border.all(
                      color: palette.primary.withValues(alpha: 0.24),
                    ),
                  ),
                  child: Text(
                    'AUTOMAÇÕES, COM CLAREZA',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: palette.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Seu próximo fluxo começa aqui.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Organize receitas, conecte etapas e acompanhe cada execução em um só lugar.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: palette.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: palette.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Acesso seguro ao seu workspace',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
