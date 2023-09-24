using DataAccess.DataModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using NBA_BAL.Services;
using NBA_DAL.Repositories;

namespace WebApp.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly ITeamManager _teamService;

        public IEnumerable<TeamSummary>? Teams { get; private set; }

        public IndexModel(ILogger<IndexModel> logger,
                ITeamManager teamService)
        {
            _logger = logger;
            _teamService = teamService;
        }

        public void OnGet()
        {
            try
            {
               Teams = _teamService.GetAllTeams();
            } catch (Exception)
            {
                throw;
            }
        }
    }
}